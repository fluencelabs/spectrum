locals {
  prefix = terraform.workspace
}

data "vault_generic_secret" "spectrum" {
  path = "kv/digitalocean/spectrum"
}

data "vault_generic_secret" "docker" {
  path = "kv/docker-registry/basicauth/ci"
}

module "talos" {
  source       = "../terraform-modules/talos"
  cluster_name = local.prefix

  control_planes = [
    {
      name      = "cp-0"
      server_ip = digitalocean_droplet.cp[0].ipv4_address
      config_patches = [
        file("${path.root}/patches/registry.yml"),
      ]
    },
  ]
}

module "spectrum" {
  depends_on = [
    module.talos
  ]
  source  = "../terraform-modules/spectrum"
  network = var.github_branch
  cluster = "ephemeral"

  cilium_hubble_enabled = true

  flux_variables = {
    PR_URL          = var.github_pr_url
    BRANCH          = var.github_branch
    DOTOKEN         = base64encode(data.vault_generic_secret.spectrum.data.token)
    DOMAIN          = "${local.prefix}.fluence.dev"
    PREFIX          = local.prefix
    LOADBALANCER_IP = digitalocean_droplet.cp[0].ipv4_address
    L2_IP           = digitalocean_reserved_ip.l2.ip_address
  }
}
