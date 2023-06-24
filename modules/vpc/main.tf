# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "my-vpc"
  }
}


# Create public subnets
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidr_blocks)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Create private subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

# Create database subnets
resource "aws_subnet" "db_subnets" {
  count             = length(var.db_subnet_cidr_blocks)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.db_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "db-subnet-${count.index + 1}"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "app_ig" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "MyIGW"
  }
}



# Public Route Table
resource "aws_route_table" "rtb-public" {
  vpc_id = aws_vpc.main_vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_ig.id
  }

  tags = {
    Name = "public-route-table-1"
  }
}



# Public Route Table Association
resource "aws_route_table_association" "association" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.rtb-public.id
}




# Elastic IPs for NAT
resource "aws_eip" "web_eip" {
  count      = length(var.private_subnet_cidr_blocks)
  vpc        = true
  depends_on = [aws_internet_gateway.app_ig]

  tags = {
    Name = "eip-${count.index + 1}"
  }
}


# Create NAT Gateways
resource "aws_nat_gateway" "web_ngw" {
  count         = length(var.private_subnet_cidr_blocks)
  allocation_id = aws_eip.web_eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = "nat-gateway ${count.index + 1}"
  }
}


# Private Route Table
resource "aws_route_table" "rtb-private" {
  count = length(var.private_subnet_cidr_blocks)
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.web_ngw[count.index].id
  }

  tags = {
    Name = "private-route-table ${count.index + 1}"
  }
}


# Private Route Table Association
resource "aws_route_table_association" "private_association" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.rtb-private[count.index].id
}


# 