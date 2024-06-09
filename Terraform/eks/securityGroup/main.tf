#creating customized security group  for web application
resource "aws_security_group" "web-security" {
  name        = "web-server"
  description = "security-web"
  vpc_id      = var.aws_vpc
  dynamic "ingress" {
    for_each = local.inbound_ports
    content {
      description = "allowing web access as well as ssh access"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "TCP"
      cidr_blocks = var.vpc_cidr
    }
  }

  dynamic "egress" {
    for_each = local.outbound_ports
    content {
        from_port   = egress.value
        to_port     = egress.value
        protocol    = "TCP"
        cidr_blocks = var.vpc_cidr
    }
  }
  tags = merge(local.common_tags , local.Name)
  
}
