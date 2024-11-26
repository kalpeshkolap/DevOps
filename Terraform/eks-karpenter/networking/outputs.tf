output "public-subnet-ids" {
  value = aws_subnet.focus-pub-sub[*].id
}

output "private-subnet-ids" {
  value = aws_subnet.focus-prt-sub[*].id
}

output "public_key" {
  value = aws_key_pair.k8s-key.key_name
}

output "vpc_id" {
  value = aws_vpc.focus.id
}