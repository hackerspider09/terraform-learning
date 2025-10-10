# ----------------------------- OUTPUTS ---------------------------------

output "eu_instance_public_ip" {
  description = "Public IP of the Europe (Stockholm) EC2 instance"
  value       = aws_instance.ec2-eu.public_ip
}

output "eu_instance_private_ip" {
  description = "Private IP of the Europe (Stockholm) EC2 instance"
  value       = aws_instance.ec2-eu.private_ip
}

output "mum_instance_public_ip" {
  description = "Public IP of the Mumbai EC2 instance"
  value       = aws_instance.ec2-mum.public_ip
}

output "mum_instance_private_ip" {
  description = "Private IP of the Mumbai EC2 instance"
  value       = aws_instance.ec2-mum.private_ip
}
