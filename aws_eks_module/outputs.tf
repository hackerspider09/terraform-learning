output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_region" {
  value = var.region
}

output "kube_config_cmd" {
  value = "aws eks update-kubeconfig --region ${var.region} --name ${var.region}"
}