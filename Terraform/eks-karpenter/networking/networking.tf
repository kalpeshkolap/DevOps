resource "aws_vpc" "focus" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"
  tags = {
    Name = "${var.clustername}-${var.env}"
  }
}

resource "aws_subnet" "focus-pub-sub" {
  count = length(slice(data.aws_availability_zones.available.names,0 ,2 ))
  vpc_id = aws_vpc.focus.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  cidr_block = cidrsubnet(var.vpc_cidr, var.subnet_prefix , count.index )
  tags = {
    Name = "focus-${var.env}-${replace(data.aws_availability_zones.available.names[count.index],"-", "")}-pub-${count.index+1}"
    "kubernetes.io/cluster/${var.clustername}-${var.env}"  =	 "owned"
    "kubernetes.io/role/elb"  =	"1"
  }
  depends_on = [aws_vpc.focus]
}

resource "aws_subnet" "focus-prt-sub" {
  count = length(slice(data.aws_availability_zones.available.names,0 ,2 ))
  vpc_id = aws_vpc.focus.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  cidr_block = cidrsubnet(var.vpc_cidr, var.subnet_prefix , count.index +2 )
  tags = {
    Name                                  = "focus-${var.env}-${replace(data.aws_availability_zones.available.names[count.index],"-", "")}-prt-${count.index+1}"
    "kubernetes.io/cluster/${var.clustername}-${var.env}"  =	 "owned"
    "kubernetes.io/role/internal-elb"  =	"1"
    "karpenter.sh/discovery" = "${var.clustername}-${var.env}"
  }
  depends_on = [aws_vpc.focus]
}

resource "aws_eip" "focus-eip" {
  tags = {
    Name = "focus-${var.env}"
  }
}

resource "aws_internet_gateway" "focus-igw" {
  vpc_id = aws_vpc.focus.id
  tags = {
    Name = "focus-${var.env}"
  }
  depends_on = [aws_vpc.focus]
}

resource "aws_nat_gateway" "focus-nat" {
  subnet_id = aws_subnet.focus-pub-sub[0].id
  allocation_id = aws_eip.focus-eip.id
  tags = {
    Name = "focus-${var.env}"
  }
  depends_on = [aws_eip.focus-eip]
}

