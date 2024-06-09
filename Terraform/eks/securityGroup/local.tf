locals {
  inbound_ports = var.inbound-ports
  outbound_ports = var.outbound-ports
}


locals {
    common_tags = {
        "kubernetes.io/cluster/${var.clustername}"  =	 "shared"
        "aws:eks:cluster-name" = "${var.clustername}"
        "Name" = "eks-cluster-sg-${var.clustername}"
    }
    env = "development"
    Name = {
        Name = "${var.clustername}-dev"
    }
}