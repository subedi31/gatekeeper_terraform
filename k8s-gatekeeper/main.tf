provider "aws" {
  version = "~> 3.0"
  region  = "us-west-1"
}

provider "helm" {
  kubernetes {
    config_path = "kubeconfig/.kube/config"
  }
}

data "aws_eks_cluster" "example" {
  name = "gitaction"
}
data "aws_eks_cluster_auth" "example" {
  name = "gitaction"
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}
resource "kubernetes_namespace" "gatekeeper" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "gatekeeper" {
  chart      = "gatekeeper"
  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  name       = var.helm_release_name
  namespace  = var.namespace
  version    = "3.5.1"

  depends_on = [
    kubernetes_namespace.gatekeeper
  ]
}

resource "helm_release" "gatekeeper-templates" {
  chart     = "${path.root}/helm-gatekeeper-templates"
  name      = "gatekeeper-templates"
  namespace = var.namespace
  version   = "0.0.3"

  depends_on = [
    helm_release.gatekeeper
  ]
}

resource "helm_release" "gatekeeper-constraints" {
  chart     = "${path.root}/helm-gatekeeper-constraints"
  name      = "gatekeeper-constraints"
  namespace = var.namespace
  version   = "0.0.3"

  depends_on = [
    helm_release.gatekeeper-templates
  ]
}
