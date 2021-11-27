provider "aws" {
  region = "us-west-2"
}
#creating an aws instance
resource "aws_instance" "dev" {
  count = length(data.aws_availability_zones.available.names)
  ami             = "ami-013a129d325529d4d"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public[count.index].id
  key_name        = "ans"
  security_groups = [aws_security_group.web-security.id]
  tags = {
    Name = "ansible-${count.index}"
  }

}