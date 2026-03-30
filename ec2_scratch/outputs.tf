output "ami_id" {
  value = data.aws_ami.ubuntu.id
}

output "key_pair_name" {
  value = data.aws_key_pair.key_pair.key_name
}

output "vpc_name" {
  value = aws_vpc.terra_vpc.tags
}

output "ec2_ip" {
  value = aws_instance.terra_ec2.public_ip
}