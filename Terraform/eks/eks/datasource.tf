data "aws_eks_cluster" "clusterid" {
  name = var.clustername
  depends_on = [ local.clusterid ]
}