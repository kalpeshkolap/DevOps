#creating an customized vpc
resource "aws_vpc" "dev-vpc" {
  cidr_block           = var.cider
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "dev-vpc"
  }
}
#creating an customized public-subnet for web-servers
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.dev-vpc.id
  count                   = length(data.aws_availability_zones.available.names)
  cidr_block              = cidrsubnet(var.cider, 2, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index}"
  }
}
#creating an internet-gateway for public-subnet
resource "aws_internet_gateway" "public-igw" {
  vpc_id = aws_vpc.dev-vpc.id
  tags = {
    Name = "public-igw"
  }
}
#creating an public route table
resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.dev-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public-igw.id

  }
}
#aws_route_table associated with public-subnet
resource "aws_route_table_association" "pub-rt-association" {
  count          = length(data.aws_availability_zones.available.names)
  route_table_id = aws_route_table.public-route.id
  subnet_id      = aws_subnet.public[count.index].id
}