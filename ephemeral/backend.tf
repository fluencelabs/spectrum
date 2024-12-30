terraform {
  backend "s3" {
    bucket = "spectrum-ci"
    key    = "state"
    region = "eu-west-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4"
    }
    talos = {
      source = "siderolabs/talos"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

data "cloudflare_zone" "fluence_dev" {
  name = "fluence.dev"
}

provider "vault" {
  address = "https://vault.fluence.dev"
}

provider "helm" {
  kubernetes {
    config_path = local_sensitive_file.kubeconfig.filename
  }
}
