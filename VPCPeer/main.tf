# -----------------------------Europe Region Network Setup---------------------------------
provider "aws" {
  alias = "stokholm-region"
  region = var.req_region
}

resource "aws_vpc" "vpc-eu" {
  provider   = aws.stokholm-region
  cidr_block = var.cidr_block_eu
  tags = {
    Name = "pra-vpc-eu"
  }
}

resource "aws_subnet" "sn-eu" {
  provider   = aws.stokholm-region
  vpc_id     = aws_vpc.vpc-eu.id
  cidr_block = var.cidr_block_eu


  tags = {
    Name = "pra-sn-eu"
  }
}

resource "aws_internet_gateway" "igw-eu" {
  provider   = aws.stokholm-region
  vpc_id = aws_vpc.vpc-eu.id

  tags = {
    Name = "pra-igw-eu"
  }
}

resource "aws_route_table" "rt-eu" {
  provider   = aws.stokholm-region
  vpc_id = aws_vpc.vpc-eu.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-eu.id
  }

  tags = {
    Name = "pra-rt-eu"
  }
}

resource "aws_route_table_association" "rta-eu" {
  provider   = aws.stokholm-region
  subnet_id      = aws_subnet.sn-eu.id
  route_table_id = aws_route_table.rt-eu.id
}

# -----------------------------Mumbai Region Network Setup---------------------------------

provider "aws" {
    alias = "mumbai-region"
    region = var.acc_region
}

resource "aws_vpc" "vpc-mum" {
  provider   = aws.mumbai-region
  cidr_block = var.cidr_block_mum
  tags = {
    Name = "pra-vpc-mum"
  }
}

resource "aws_subnet" "sn-mum" {
  provider   = aws.mumbai-region
  vpc_id     = aws_vpc.vpc-mum.id
  cidr_block = var.cidr_block_mum

  tags = {
    Name = "pra-sn-mum"
  }
}

resource "aws_internet_gateway" "igw-mum" {
  provider   = aws.mumbai-region
  vpc_id = aws_vpc.vpc-mum.id

  tags = {
    Name = "pra-igw-mum"
  }
}

resource "aws_route_table" "rt-mum" {
  provider   = aws.mumbai-region
  vpc_id = aws_vpc.vpc-mum.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-mum.id
  }

  tags = {
    Name = "pra-rt-mum"
  }
}

resource "aws_route_table_association" "rta-mum" {
  provider   = aws.mumbai-region
  subnet_id      = aws_subnet.sn-mum.id
  route_table_id = aws_route_table.rt-mum.id
}

# -----------------------------Europe Region VPC Peer Setup---------------------------------

# this is the requester and main peering request with id
resource "aws_vpc_peering_connection" "req-eu-mum" {
  provider   = aws.stokholm-region
  vpc_id        = aws_vpc.vpc-eu.id
  peer_vpc_id   = aws_vpc.vpc-mum.id

  peer_region   = var.acc_region
  auto_accept   = false

  tags = {
    Name = "pra-req-eu-mum"
  }
}

# this is the accepter part of the peering connection
resource "aws_vpc_peering_connection_accepter" "acc-eu-mum" {
  provider                  = aws.mumbai-region
  vpc_peering_connection_id = aws_vpc_peering_connection.req-eu-mum.id
  auto_accept               = true

  tags = {
    Name = "pra-acc-eu-mum"
  }
}


resource "aws_route" "eu-to-mum" {
  provider                  = aws.stokholm-region
  route_table_id            = aws_route_table.rt-eu.id
  destination_cidr_block    = var.cidr_block_mum
  vpc_peering_connection_id = aws_vpc_peering_connection.req-eu-mum.id
}

resource "aws_route" "mum-to-eu" {
  provider                  = aws.mumbai-region
  route_table_id            = aws_route_table.rt-mum.id
  destination_cidr_block    = var.cidr_block_eu
  vpc_peering_connection_id = aws_vpc_peering_connection.req-eu-mum.id
}

# -----------------------------Create 2 Instances---------------------------------

# -----------------------------Create Key Pair in Both Regions-----------------------------

# Upload local public key to Stockholm
resource "aws_key_pair" "local_ssh_key_eu" {
  provider   = aws.stokholm-region
  key_name   = "pra-local-key-eu"
  public_key = file(var.public_key_path)
}

# Upload local public key to Mumbai
resource "aws_key_pair" "local_ssh_key_mum" {
  provider   = aws.mumbai-region
  key_name   = "pra-local-key-mum"
  public_key = file(var.public_key_path)
}


# -----------------------------Europe Region Instance Setup---------------------------------

# security group
resource "aws_security_group" "sg-eu" {
  provider    = aws.stokholm-region
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc-eu.id

  tags = {
    Name = "pra-sg-eu"
  }
}

# ingress rules 
resource "aws_vpc_security_group_ingress_rule" "allow-ssh-eu" {
  provider    = aws.stokholm-region
  security_group_id = aws_security_group.sg-eu.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# egress
resource "aws_vpc_security_group_egress_rule" "allow-all-traffic-eu" {
  provider    = aws.stokholm-region
  security_group_id = aws_security_group.sg-eu.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "ec2-eu" {
  provider    = aws.stokholm-region
  ami           = "ami-0a716d3f3b16d290c"
  instance_type = "t3.micro"
  associate_public_ip_address = true

  subnet_id              = aws_subnet.sn-eu.id
  vpc_security_group_ids = [aws_security_group.sg-eu.id]
  key_name = aws_key_pair.local_ssh_key_eu.key_name
  tags = {
    Name = "pra-ec2-eu"
  }
}
# -----------------------------Mumbai Region Instance Setup---------------------------------

# security group
resource "aws_security_group" "sg-mum" {
  provider    = aws.mumbai-region
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc-mum.id

  tags = {
    Name = "pra-sg-mum"
  }
}

# ingress rules 
resource "aws_vpc_security_group_ingress_rule" "allow-ssh-mum" {
  provider    = aws.mumbai-region
  security_group_id = aws_security_group.sg-mum.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# egress
resource "aws_vpc_security_group_egress_rule" "allow-all-traffic-mum" {
  provider    = aws.mumbai-region
  security_group_id = aws_security_group.sg-mum.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "ec2-mum" {
  provider    = aws.mumbai-region
  ami           = "ami-02d26659fd82cf299"
  instance_type = "t3.micro"
  associate_public_ip_address = true

  subnet_id              = aws_subnet.sn-mum.id
  vpc_security_group_ids = [aws_security_group.sg-mum.id]
  key_name = aws_key_pair.local_ssh_key_mum.key_name
  tags = {
    Name = "pra-ec2-mum"
  }
}