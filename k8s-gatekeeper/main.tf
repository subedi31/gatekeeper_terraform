#provider "aws" {
#  version = "~> 4.0"
#  region  = "us-west-1"
#}
provider "kubernetes" {
  #config_path = "${path.root}/.kube/config"
  config_path = "~/.kube/config"
  config_context = "minikube"
}

provider "helm" {
  kubernetes {
  #config_path = "${path.root}/.kube/config"
  config_path = "~/.kube/config"
  config_context = "minikube"
  }
}

resource "kubernetes_namespace" "gatekeeper" {
  metadata {
   name = var.namespace
 }
}

# Add the Helm repository
resource "helm_release" "gatekeeper" {
  name = "gatekeeper"
  repository  = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart      = "gatekeeper"
  namespace  = "gatekeeper-system"
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