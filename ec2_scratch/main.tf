


# VPC
resource "aws_vpc" "terra_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Terra_vpc"
  }
}

# Subnet
resource "aws_subnet" "terra_sn" {
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Terra_pub_sn"
  }
}

# Route table
resource "aws_route_table" "terra_rt" {
  vpc_id = aws_vpc.terra_vpc.id

  route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_internet_gateway.terra_igw.id
  }

  tags = {
    Name = "Terra_rt"
  }
}

# Route table assosiation
resource "aws_route_table_association" "rt_ass_sn" {
  subnet_id      = aws_subnet.terra_sn.id
  route_table_id = aws_route_table.terra_rt.id
}

# IG
resource "aws_internet_gateway" "terra_igw" {
  vpc_id = aws_vpc.terra_vpc.id

  tags = {
    Name = "Terra_igw"
  }
}

# Attach IG to vpc
resource "aws_internet_gateway_attachment" "terra_igw_attch" {
  internet_gateway_id = aws_internet_gateway.terra_igw.id
  vpc_id              = aws_vpc.terra_vpc.id
}


