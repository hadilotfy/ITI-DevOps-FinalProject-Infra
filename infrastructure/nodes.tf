resource "aws_iam_role" "nodes" {
  name = "eks-node-group-nodes"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.webapp-cluster.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = module.subnets.private_subnets_ids
  # ON_DEMAND   SPOT is cheeper
  capacity_type  = "SPOT"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_launch_template" "jenkins-disk" {
  name = "jenkins-disk"
  key_name = "aws_key2"
  block_device_mappings {
    device_name = "/dev/xvdb"
    ebs {
      volume_size = 3
      volume_type = "gp2"
      delete_on_termination = false
    }
  }
}

resource "aws_eks_node_group" "private-jenkins-node" {
  cluster_name    = aws_eks_cluster.webapp-cluster.name
  node_group_name = "private-jenkins-node"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = module.subnets.private_subnets_ids
  # ON_DEMAND   SPOT is cheeper
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  labels = {
    role = "jenkins"
  }

  launch_template {
    name    = aws_launch_template.jenkins-disk.name
    version = aws_launch_template.jenkins-disk.latest_version
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# issue: need to assign an ebs volume to the node where jenkins is used.
#        which means 
#           - it will be a specific node with some label
#           - jenkins deployment will have node affinity to it.


# issue: Two choices:-   OK
#   1-  make jenkins node a public node     (disapproved choice)
#         - will have a public ip
#         - need to make it so app pods do not run on that node
#   2-  make it private                     (approved)
#         - need the load balancer to directo trafic to it.




# taint {
  #   key    = "team"
  #   value  = "devops"
  #   effect = "NO_SCHEDULE"
  # }


# test_policy_arn = "arn:aws:iam::385582076770:role/test-oidc"
# aws eks --region us-east-1 update-kubeconfig --name webapp-cluster --profile terraform
# aws_eks_node_group.private-jenkins-node








# resource "aws_ebs_volume" "example" {
#   availability_zone = "${data.aws_availability_zones.azones.names[0]}"
#   size              = 1
# }

# resource "aws_volume_attachment" "ebs_att" {
#   device_name = "/dev/sdh-jenkins"
#   volume_id   = aws_ebs_volume.example.id
#   instance_id = aws_eks_node_group.private-jenkins-node.
# }
# output "jenkins-node" {
#   value = aws_eks_node_group.private-jenkins-node.disk_size
# }

# data "aws_availability_zones" "azones" {
#     state = "available"
# }
