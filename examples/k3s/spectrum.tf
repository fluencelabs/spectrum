provider "helm" {
  kubernetes {
    config_path = module.k3s.kubeconfig_file
  }
}

module "spectrum" {
  depends_on      = [module.k3s]
  source          = "git::https://github.com/fluencelabs/spectrum.git//terraform-modules/spectrum?ref=terraform-module-spectrum-v0.1.3" # x-release-please-version
  cluster_flavour = "k3s"
}
