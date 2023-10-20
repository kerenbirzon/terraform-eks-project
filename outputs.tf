output "kubeconfig" {
  value = module.eks.kubeconfig
}
output "config_map_aws_auth" {
  value = module.eks.config_map_aws_auth
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}