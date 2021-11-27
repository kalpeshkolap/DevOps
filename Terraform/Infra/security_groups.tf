#creating customized security group  for web application
resource "aws_security_group" "web-security" {
  name        = "web-server"
  description = "security-web"
  vpc_id      = aws_vpc.dev-vpc.id
  dynamic "ingress" {
    for_each = var.security-web
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "Web-security_group"
  }
}
#creating security group for database security
resource "aws_security_group" "db-security" {
  name        = "database"
  description = "security-db"
  vpc_id      = aws_vpc.dev-vpc.id
  dynamic "ingress" {
    for_each = var.security-db
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.security-db
    content {
      description = egress.value.description
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }

  }
  tags = {
    Name = "db-security"
  }
}