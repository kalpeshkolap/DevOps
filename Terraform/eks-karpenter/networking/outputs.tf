output "public-subnet-ids" {
  value = aws_subnet.focus-pub-sub[*].id
}

output "private-subnet-ids" {
  value = aws_subnet.focus-prt-sub[*].id
}