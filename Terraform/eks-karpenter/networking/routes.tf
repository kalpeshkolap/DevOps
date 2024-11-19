resource "aws_route_table" "focus-pub-rt" {
  vpc_id = aws_vpc.focus.id
  route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.focus-igw.id
  }
  tags = {
    Name = "focus-${var.env}-pub"
  }
}

resource "aws_route_table_association" "focus-pub-rt-association" {
  count = length(slice(data.aws_availability_zones.available.names,0 ,2 ))
  route_table_id = aws_route_table.focus-pub-rt.id
  subnet_id = aws_subnet.focus-pub-sub[count.index].id
}

resource "aws_route_table" "focus-prt-rt" {
  vpc_id = aws_vpc.focus.id
  route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_nat_gateway.focus-nat.id
  }
  tags = {
    Name = "focus-${var.env}-prt"
  }
}

resource "aws_route_table_association" "focus-prt-rt-association" {
  count = length(slice(data.aws_availability_zones.available.names,0 ,2 ))
  route_table_id = aws_route_table.focus-prt-rt.id
  subnet_id = aws_subnet.focus-prt-sub[count.index].id
}