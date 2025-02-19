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
  name = "talos-v1.9.2"
}

resource "digitalocean_droplet" "cp" {
  count    = 1
  name     = "rnd-${local.prefix}-spectrum-cp-${count.index}"
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

# mayastor volume
resource "digitalocean_volume" "mayastor" {
  region                  = "fra1"
  name                    = "rnd-${local.prefix}-spectrum-cp"
  size                    = "100"
}

resource "digitalocean_volume_attachment" "mayastor" {
  droplet_id = digitalocean_droplet.cp[0].id
  volume_id  = digitalocean_volume.mayastor.id
}
