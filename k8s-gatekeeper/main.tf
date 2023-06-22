provider "aws" {
  version = "~> 4.0"
  region  = "us-west-1"
}
provider "kubernetes" {
  config_path = "${path.root}/.kube/config"
}

provider "helm" {
  kubernetes {
  config_path = "${path.root}/.kube/config"
  }
}

resource "kubernetes_namespace" "gatekeeper" {
  metadata {
   name = var.namespace
 }
}

resource "helm_release" "gatekeeper" {
  chart      = "gatekeeper"
  repository = "https://github.com/open-policy-agent/gatekeeper/tree/master/charts/gatekeeper/crds"
  name       = var.helm_release_name
  namespace  = var.namespace

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
