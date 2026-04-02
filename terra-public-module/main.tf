# Create VPC and subnet by aws vpc module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Terra-Network"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = local.common_tags
}


module "web_sg" {
  source = "./modules/security-group"

  vpc_id = module.vpc.vpc_id

  sg_name = "Terra-sg"

  ingress_ports = [22,80,443]

  tags = local.common_tags
}


module "web_server" {
  source             = "./modules/ec2-instance"
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.public_subnets[0]
  security_group_ids = [module.web_sg.sg_id]
  instance_name      = "Terra-web"
  tags               = local.common_tags
}

module "api_server" {
  source             = "./modules/ec2-instance"
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.private_subnets[0]
  security_group_ids = [module.web_sg.sg_id]
  instance_name      = "Terra-API"
  tags               = local.common_tags
}