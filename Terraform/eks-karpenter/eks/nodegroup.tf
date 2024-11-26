resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = "${var.clustername}-${var.env}"
  node_group_name = var.node-group-name
  node_role_arn   = aws_iam_role.NodeRole.arn
  subnet_ids      = var.private-subnets
  disk_size       = var.disk-size
  capacity_type   = var.capacity-type
  instance_types  = [for instance in var.instance-type : instance]
  remote_access {
    ec2_ssh_key               = var.ec2-ssh-key
    source_security_group_ids = var.security_group_id
  }
  scaling_config {
    desired_size = 1
    max_size     = 1
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
    local.clusterid
  ]
  tags = {
    "karpenter.sh/discovery" = "${var.clustername}-${var.env}"
    Name                     = "focus-${var.env}-node"
  }
}