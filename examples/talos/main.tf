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
  source       = "git::https://github.com/fluencelabs/spectrum.git//terraform-modules/talos?ref=terraform-module-talos-v0.2.2" # x-release-please-version
  cluster_name = "my-cluster"

  control_planes = [
    {
      name      = "cp-0"
      server_ip = "1.2.3.4"
      config_patches = [
        file("${path.root}/patch.yml"),
      ]
    },
  ]
}
