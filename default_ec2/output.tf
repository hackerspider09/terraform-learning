output "keypair-name" {
  value = data.aws_key_pair.keypair_ec2.key_name
  description = "Name of existing key pair on aws dashboard"
}

output "keypair-id" {
  description = "ID of existing key pair on aws dashboard"
  value = data.aws_key_pair.keypair_ec2.id
}

output "ec2-publicip" {
  description = "Public ip of ec2"
  value = aws_instance.terra_ec2.public_ip
}