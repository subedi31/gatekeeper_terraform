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

#resource "kubernetes_namespace" "gatekeeper" {
#  metadata {
#   name = var.namespace
# }
#}

# Add the Helm repository
resource "helm_repository" "gatekeeper" {
  name = "gatekeeper"
  url  = "https://open-policy-agent.github.io/gatekeeper/charts"
}

# Install the Helm chart
resource "helm_release" "gatekeeper" {
  name      = "gatekeeper"
  repository = helm_repository.gatekeeper.name
  chart     = "gatekeeper"
  namespace = "gatekeeper-system"

  create_namespace = true
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
