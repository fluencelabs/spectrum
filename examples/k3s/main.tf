module "k3s" {
  source               = "git::https://github.com/fluencelabs/spectrum.git//terraform-modules/k3s?ref=terraform-module-k3s-v0.1.0" # x-release-please-version
  kubeconfigs_location = "${path.root}/secrets"
  server_name          = local.server_name
  server_ip_address    = local.server_ip_address
  ssh_key              = local.ssh_key
  ssh_user             = local.ssh_user
  ssh_port             = local.ssh_port
}
