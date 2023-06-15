provider "aws" {
  version = "~> 3.0"
  region  = "us-west-1"
}

provider {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.21.1"
    }
  }
provider {
    helm = {
      source = "hashicorp/helm"
      version = "2.10.1"
    }
  }