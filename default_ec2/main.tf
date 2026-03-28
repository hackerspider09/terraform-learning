# Get crnt region by query the crnt region value from provider
data "aws_region" "region" {}

# VPC use default one
resource "aws_default_vpc" "default_VPC" {
}

# Use subnet by creating one snm1
# resource "aws_subnet" "terra-sn" {
#   vpc_id = aws_default_vpc.default_VPC.id
#   cidr_block = "172.31.4.0/24"
#   tags = {
#     Name = "terra-sn"
#   }
# }

# Use existing subnet snm2
data "aws_subnets" "terra-sn" {
   filter {
    name = "vpc-id"
    values = [aws_default_vpc.default_VPC.id]
  }
}


# Security group
resource "aws_security_group" "terra_sg" {
  name        = "terra_tls_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default_VPC.id

  tags = {
    Name = "terra_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.terra_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.terra_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.terra_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# Key pair use existing one
data "aws_key_pair" "keypair_ec2" {
  key_name           = "test-key-pair"
  include_public_key = true
}


# EC2
resource "aws_instance" "terra_ec2" {
  ami = "ami-0ec10929233384c7f"
  instance_type = "t2.micro"

  key_name = data.aws_key_pair.keypair_ec2.key_name
  
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.terra_sg.id]
  
  # snm1
  # subnet_id = aws_subnet.terra-sn.id

  # snm2
  subnet_id = data.aws_subnets.terra-sn.ids[0]
  
  tags= {
    Name = "terra-ec2"
  }
}