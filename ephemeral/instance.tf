data "digitalocean_vpc" "spectrum" {
  name = "rnd-spectrum-vpc"
}

resource "tls_private_key" "spectrum" {
  algorithm = "ED25519"
}

resource "digitalocean_ssh_key" "spectrum" {
  name       = "${local.prefix}-ssh-key"
  public_key = tls_private_key.spectrum.public_key_openssh
}

data "digitalocean_image" "talos" {
  name = "talos-v1.9.1"
}

resource "digitalocean_droplet" "talos" {
  name     = "rnd-${local.prefix}-spectrum-cp"
  size     = "s-8vcpu-16gb"
  image    = data.digitalocean_image.talos.id
  region   = "fra1"
  vpc_uuid = data.digitalocean_vpc.spectrum.id

  ssh_keys = [
    digitalocean_ssh_key.spectrum.id
  ]

  tags = [
    local.prefix,
  ]
}

resource "digitalocean_reserved_ip" "l2" {
  droplet_id = digitalocean_droplet.talos.id
  region     = digitalocean_droplet.talos.region
}
