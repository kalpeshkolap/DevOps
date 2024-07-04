output "eks_cluster_id" {
    value = data.aws_eks_cluster.clusterid.id
}

output "clusterid" {
    value = local.clusterid
}