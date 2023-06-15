provider "aws" {
  version = "~> 3.0"
  region  = "us-west-1"
}

providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.21.1"
    }
  }
providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.10.1"
    }
  }