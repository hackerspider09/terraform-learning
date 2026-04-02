output "vpc_id" {
  value = "VPC ID => ${module.vpc.vpc_id}"
}

output "sg_id" {
  value = "SG ID => ${module.web_sg.sg_id}"
}

# ec2
output "terra_web" {
  value = "Public IP: ${module.web_server.public_ip} | Private IP: ${module.web_server.private_ip} | "
}

output "terra_api" {
  value = "Public IP: ${module.api_server.public_ip} | Private IP: ${module.api_server.private_ip} | "
}