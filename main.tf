module "my-aws-network" {
    source = "./modules/aws-network"
  
    env_prefix = "dev"
    aws_region = "us-east-1"
    vpc_name = "my-vpc"
    vpc_cidr_block = "10.0.0.0/16"
    subnet_map_public_ip_on_launch = true
    cluster_name = "terraform-eks"
}

module "eks" {
    source = "./modules/eks"
    vpc_id = module.my-aws-network.vpc_id
    subnet_id = module.my-aws-network.subnet_id
    env_prefix = "dev"
    cluster_name = "terraform-eks"
    cluster_role_name = "terraform-eks-role"
    cluster_assume_role_policy =<<POLICY
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "eks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
    }
    POLICY
    cluster_AmazonEKSClusterPolicy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    cluster_AmazonEKSVPCResourceControllerPolicy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
    cluster_security_group_name = "terraform-eks-security-group"

    node_role_name = "terraform-eks-node-role"
    node_role_assume_role_policy =<<POLICY
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
    }
    POLICY
    node_role_AmazonEKSWorkerNodePolicy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    node_role_AmazonEKS_CNI_Policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    node_role_AmazonEC2ContainerRegistryReadOnly_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    node_group_name = "terraform-node-group"
}

module "kubernetes" {
    source = "./modules/kubernetes"
    env_prefix = "dev"
    argocd_namespace = "argocd"
    eks_cluster_endpoint = module.eks.cluster_endpoint
    eks_cluster_ca_certificate = module.eks.cluster_ca_certificate
    eks_cluster_name = module.eks.cluster_name
    helm_release_name = "argocd"
    helm_release_repo = "https://argoproj.github.io/argo-helm"
    helm_release_chart = "argo-cd"
}
