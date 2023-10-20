provider "kubernetes" {
  config_path = "~/.kube/config"
}
resource "kubernetes_namespace" "argocd-namespace" {
  metadata {
    annotations = {
      name = var.argocd_namespace
    }
    name = var.argocd_namespace
  }
}

provider "helm" {
  kubernetes {
    host                   = var.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(var.eks_cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
      command     = "aws"
    }
  }
}

resource "helm_release" "argocd" {
  name       = var.helm_release_name
  repository = var.helm_release_repo
  chart      = var.helm_release_chart
  namespace = var.argocd_namespace
}