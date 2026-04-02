resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  
  subnet_id = var.subnet_id

  # Use vpc_security_group_ids instead of security_groups because this EC2 is inside a VPC.
# security_groups expects SG names and can cause Terraform to recreate the instance every plan.
  vpc_security_group_ids  = var.security_group_ids 

  associate_public_ip_address = true
  
  tags = merge(
    {
      Name = var.instance_name
    },
    var.tags
  )
}