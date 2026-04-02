module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version

  # make false after test
  endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    terra_nodes = {
      ami_tyoe = "AL2_x86_64"
      instance_type = [var.node_instance_type]

      min_size = 1
      max_size = 3
      desired_size = var.node_desired_count
    }
  }

  tags = local.common_tags
}