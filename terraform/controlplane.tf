locals {
  cp = [
    for i in range(3) : format("%s-%d", "cp", i)
  ]
}

resource "digitalocean_loadbalancer" "cp" {
  name     = "${local.prefix}-controlplane"
  region   = "fra1"
  vpc_uuid = data.digitalocean_vpc.spectrum.id

  forwarding_rule {
    entry_port      = 80
    entry_protocol  = "tcp"
    target_port     = 30100
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_port      = 443
    entry_protocol  = "tcp"
    target_port     = 30101
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_protocol  = "tcp"
    entry_port      = 6443
    target_protocol = "tcp"
    target_port     = 6443
  }

  forwarding_rule {
    entry_protocol  = "tcp"
    entry_port      = 50000
    target_protocol = "tcp"
    target_port     = 50000
  }

  healthcheck {
    protocol          = "tcp"
    port              = 6443
    healthy_threshold = 2
  }

  droplet_tag = "${local.prefix}-controlplane"
}

resource "cloudflare_record" "endpoint" {
  zone_id = data.cloudflare_zone.fluence_dev.zone_id
  name    = "kube.${local.prefix}.fluence.dev"
  content = digitalocean_loadbalancer.cp.ip
  type    = "A"
}

resource "talos_machine_secrets" "this" {
  talos_version = "v1.8"
}

data "talos_machine_configuration" "cp" {
  for_each = { for index, name in local.cp : name => index }

  cluster_name     = terraform.workspace
  machine_type     = "controlplane"
  cluster_endpoint = "https://${local.loadbalancer_dns}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  talos_version    = "v1.8"
  config_patches = [
    templatefile("${path.module}/templates/controlplane_patch.yml", {
      loadbalancerdns = "${local.loadbalancer_dns}",
      hostdns         = "${each.key}.${local.prefix}.fluence.dev",
      subnet          = data.digitalocean_vpc.spectrum.ip_range,
      branch          = var.github_branch
    })
  ]
}

data "talos_client_configuration" "this" {
  cluster_name         = terraform.workspace
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints = [
    local.loadbalancer_dns,
  ]
}

resource "digitalocean_droplet" "cp" {
  for_each = { for index, name in local.cp : name => index }

  name      = "${local.prefix}-spectrum-${each.key}"
  size      = "s-2vcpu-4gb"
  image     = data.digitalocean_image.talos.id
  region    = "fra1"
  vpc_uuid  = data.digitalocean_vpc.spectrum.id
  user_data = data.talos_machine_configuration.cp[each.key].machine_configuration

  ssh_keys = [
    digitalocean_ssh_key.spectrum.id
  ]

  tags = [
    local.prefix,
    "${local.prefix}-controlplane",
  ]
}

resource "cloudflare_record" "cp" {
  for_each = { for index, name in local.cp : name => index }

  zone_id = data.cloudflare_zone.fluence_dev.zone_id
  name    = "${each.key}.${local.prefix}.fluence.dev"
  content = digitalocean_droplet.cp[each.key].ipv4_address
  type    = "A"
}

resource "talos_machine_bootstrap" "bootstrap" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = digitalocean_droplet.cp["cp-0"].ipv4_address
  node                 = digitalocean_droplet.cp["cp-0"].ipv4_address

  lifecycle {
    replace_triggered_by = [
      digitalocean_droplet.cp["cp-0"].id
    ]
  }
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = digitalocean_droplet.cp["cp-0"].ipv4_address
}

#data "talos_cluster_health" "health" {
#  client_configuration = data.talos_client_configuration.this.client_configuration
#  control_plane_nodes  = [for droplet in digitalocean_droplet.cp : droplet.ipv4_address]
#  endpoints            = data.talos_client_configuration.this.endpoints
#}
