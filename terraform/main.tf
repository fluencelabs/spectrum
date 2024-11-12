locals {
  prefix           = "rnd-${terraform.workspace}"
  loadbalancer_dns = "kube.${local.prefix}.fluence.dev"

  docker_config_json = jsonencode({
    auths = {
      "docker.fluence.dev" = {
        username = data.vault_generic_secret.docker.data.username
        password = data.vault_generic_secret.docker.data.password
      }
    }
  })
}

resource "tls_private_key" "spectrum" {
  algorithm = "ED25519"
}

resource "digitalocean_ssh_key" "spectrum" {
  name       = "${local.prefix}-ssh-key"
  public_key = tls_private_key.spectrum.public_key_openssh
}

data "digitalocean_image" "talos" {
  name = "talos-v1.8.2"
}

data "vault_generic_secret" "spectrum" {
  path = "kv/digitalocean/spectrum"
}

data "vault_generic_secret" "docker" {
  path = "kv/docker-registry/basicauth/ci"
}
