# get ami 
data "aws_ami" "ubuntu" {
  most_recent = true  # if there are multiple match it returns mewest one

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Get key pair
data "aws_key_pair" "key_pair" {
  # key_name = "key_name"
  include_public_key = true

  filter {
    name   = "tag:env"
    values = ["dev"]
  }
}


# ec2
resource "aws_instance" "terra_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  # associate_public_ip_address = true  # if ec2 didnt get ip use this
  key_name = data.aws_key_pair.key_pair.key_name
  root_block_device {
    volume_size = 10
  }
  
  security_groups = [ aws_security_group.terra_sg.id ]
  subnet_id = aws_subnet.terra_sn.id
  
  tags = {
    Name = "Terra_ec2"
  }
}
