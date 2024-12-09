output "cluster_endpoint" {
  value = aws_eks_cluster.focus.endpoint
}

output "cluster_ca_crt" {
  value = aws_eks_cluster.focus.certificate_authority
}

output "cluster_name" {
  value = aws_eks_cluster.focus.name
}

output "karpenterrolearn" {
  value = aws_iam_role.Karpenter-Role.arn
}