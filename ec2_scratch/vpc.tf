

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
  map_public_ip_on_launch = true
  tags = {
    Name = "Terra_pub_sn"
  }
}

# Route table
resource "aws_route_table" "terra_rt" {
  vpc_id = aws_vpc.terra_vpc.id

  # Route define where traffic goes
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra_igw.id
  }

  tags = {
    Name = "Terra_rt"
  }
}

# This will replace default rt created by AWS with owr created one
# by default aws creates route table and attche to vpc at its main rt
# to make out rt main use main rt association
resource "aws_main_route_table_association" "terra_main_rt" {
  vpc_id         = aws_vpc.terra_vpc.id
  route_table_id = aws_route_table.terra_rt.id
}

# Route table assosiation
# Association determines which subnets use thode rules
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

# Attach IG to vpc (as in IG block we are already attached to vpc so doesnt need to reattach)
# resource "aws_internet_gateway_attachment" "terra_igw_attch" {
#   internet_gateway_id = aws_internet_gateway.terra_igw.id
#   vpc_id              = aws_vpc.terra_vpc.id
# }

# Security group
resource "aws_security_group" "terra_sg" {
  name        = "Terra_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.terra_vpc.id

  tags = {
    Name = "Terra_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.terra_sg.id
  cidr_ipv4         = "0.0.0.0/0"  # This is source cidr so it should be 0.0.0.0 for outside access or may be internal
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  tags = {
    "Name" = "Allow_http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.terra_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags = {
    "Name" = "Allow_ssh"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.terra_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
