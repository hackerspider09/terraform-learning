module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version

  endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true
  

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  addons = {
    vpc-cni = {
      before_compute = true
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    terra_nodes = {
      ami_type = "AL2_x86_64"
      instance_types = [var.node_instance_type]

      min_size = 1
      max_size = 3
      desired_size = var.node_desired_count
    }
  }

  tags = local.common_tags
}