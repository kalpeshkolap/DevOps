# EC2 Instance
resource "aws_instance" "myec2vm" {
  ami = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  key_name = var.instance_keypair
  security_groups = toset([var.security_group_id])
  subnet_id = var.subnet_id_bashion[0]
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    "Name" = "bashion"
  }

}