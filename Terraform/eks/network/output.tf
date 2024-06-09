output "vpc_id" {
  value = aws_vpc.xenium-vpc.id
}

output "xenium-pub-subnet" {
  value = aws_subnet.xenium-subnet-pub.id
}

output "xenium-prt-subnet" {
  value = aws_subnet.xenium-subnet-prt.id
}