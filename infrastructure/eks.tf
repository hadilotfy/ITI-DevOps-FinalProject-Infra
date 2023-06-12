resource "aws_iam_role" "culster_role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.culster_role.name
}

resource "aws_eks_cluster" "webapp-cluster" {
  name     = "webapp-cluster"
  role_arn = aws_iam_role.culster_role.arn

  vpc_config {
    subnet_ids = concat(module.subnets.public_subnets_ids,module.subnets.private_subnets_ids)
  }
  depends_on = [aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy]
}

