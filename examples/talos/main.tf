terraform {
  # Is is highly recommended to setup remote terraform state
  # backend "s3" {
  #   bucket = "mybucket"
  #   key    = "path/to/my/key"
  #   region = "us-east-1"
  # }

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.16"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = module.talos.kubeconfig.path
  }
}

module "talos" {
  source       = "git::https://github.com/fluencelabs/spectrum.git//terraform-modules/talos?ref=main"
  cluster_name = var.cluster_name
  server_ip    = var.server_ip
  # config_patches = [
  #   file("${path.root}/config_path.yml"),
  # ]
}

module "spectrum" {
  depends_on = [module.talos]
  source     = "git::https://github.com/fluencelabs/spectrum.git//terraform-modules/spectrum?ref=main"
  network    = "main"
  cluster    = "default"
}

variable "server_ip" {
  type        = string
  description = "IP at which server is accessible"
}

variable "cluster_name" {
  type        = string
  description = "Name used in k8s and talos to distinguish between clusters"
}
