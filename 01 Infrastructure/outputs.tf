# output "node-ip" {
# }

output "Cluster_End_Point"{
    value = aws_eks_cluster.webapp-cluster.endpoint
}
output "Cluster_Certificate_authority"{
    value = aws_eks_cluster.webapp-cluster.certificate_authority
}
