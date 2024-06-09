resource "aws_internet_gateway" "public-igw" {
  vpc_id = var.aws_vpc
  tags  = {
    env = "${local.env}"
  } 
}

resource "aws_route_table" "public-route" {
  vpc_id = var.aws_vpc
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public-igw.id
  }
  tags  = {
    env = "${local.env}"
  }
}

resource "aws_route_table_association" "pub-rt-association" {
  route_table_id = aws_route_table.public-route.id
  subnet_id      = var.xenium-pub-subnet
}

resource "aws_route_table" "private-route" {
  vpc_id = var.aws_vpc
  route {
      cidr_block      = "0.0.0.0/0"
      nat_gateway_id  = aws_nat_gateway.nat.id
  }
  tags  = {
    env = "${local.env}"
    Name = "${local.Name}-prt-tb"
  }
}

resource "aws_route_table_association" "prt-rt-association" {
  subnet_id      = var.xenium-prt-subnet
  route_table_id = aws_route_table.private-route.id
}

resource "aws_eip" "nat" {
  tags = {    
    env = "${local.env}"
    Name = "${local.Name}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     =  var.xenium-pub-subnet
  tags = {    
    env = "${local.env}"
    Name = "${local.Name}-nat-gw"
  }
  depends_on = [aws_internet_gateway.public-igw]
}
