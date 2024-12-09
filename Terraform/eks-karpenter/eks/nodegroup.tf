resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = "${var.clustername}-${var.env}"
  node_group_name = var.node-group-name
  node_role_arn   = aws_iam_role.NodeRole.arn
  subnet_ids      = var.private-subnets
  capacity_type   = var.capacity-type
  ami_type = "CUSTOM"
  launch_template {
    version = "$Latest"
    id = aws_launch_template.eks_node_group.id
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
    Name = "focus-${var.env}-node"
  }
}

#ami-056899329d49c452b