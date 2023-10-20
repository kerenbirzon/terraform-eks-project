
variable "env_prefix" {}

variable "vpc_id" {}
variable "subnet_id" {}
variable "cluster_name" {}
variable "cluster_role_name" {}
variable "cluster_assume_role_policy" {}
variable "cluster_AmazonEKSClusterPolicy_arn" {}
variable "cluster_AmazonEKSVPCResourceControllerPolicy_arn" {}
variable "cluster_security_group_name" {}

variable "node_role_name" {}
variable "node_role_assume_role_policy" {}
variable "node_role_AmazonEKSWorkerNodePolicy_arn" {}
variable "node_role_AmazonEKS_CNI_Policy_arn" {}
variable "node_role_AmazonEC2ContainerRegistryReadOnly_arn" {}
variable "node_group_name" {}

