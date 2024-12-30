locals {
  prefix    = terraform.workspace
  public_ip = aws_instance.talos.public_ip
}

data "vault_generic_secret" "spectrum" {
  path = "kv/digitalocean/spectrum"
}

data "vault_generic_secret" "docker" {
  path = "kv/docker-registry/basicauth/ci"
}

module "talos" {
  depends_on   = [aws_ec2_fleet.talos]
  source       = "../terraform-modules/talos"
  cluster_name = local.prefix
  server_ip    = local.public_ip

  config_patches = [
    file("${path.root}/config_patch.yml"),
  ]
}

# module "spectrum" {
#   depends_on = [
#     data.http.talos_health,
#     local_sensitive_file.kubeconfig,
#   ]
#   source  = "../terraform-modules/spectrum"
#   network = var.github_branch
#   cluster = "ephemeral"
#
#   cilium_hubble_enabled = true
#
#   flux_variables = {
#     PR_URL          = var.github_pr_url
#     BRANCH          = var.github_branch
#     DOTOKEN         = base64encode(data.vault_generic_secret.spectrum.data.token)
#     DOMAIN          = "${local.prefix}.fluence.dev"
#     PREFIX          = local.prefix
#     LOADBALANCER_IP = local.public_ip
#     L2_IP           = aws_ep.l2ip.public_ip
#   }
# }
