locals {
  cp = [
    for i in range(1) : format("%s-%d", "cp", i)
  ]
}

resource "digitalocean_loadbalancer" "cp" {
  name     = "rnd-${local.prefix}-controlplane"
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

resource "digitalocean_record" "endpoint" {
  domain = digitalocean_domain.spectrum.id
  type   = "A"
  name   = "kube"
  value  = digitalocean_loadbalancer.cp.ip
  ttl    = 30
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
      loadbalancerdns = "kube.${local.prefix}.fluence.dev"
      loadbalancerip  = digitalocean_loadbalancer.cp.ip
      hostdns         = "${each.key}.${local.prefix}.fluence.dev",
      subnet          = data.digitalocean_vpc.spectrum.ip_range,
      branch          = var.github_branch
      dotoken         = base64encode(data.vault_generic_secret.spectrum.data.token)
      domain          = "${local.prefix}.fluence.dev"
      prefix          = local.prefix
      pr_url          = var.github_pr_url
      docker_username = data.vault_generic_secret.docker.data.username
      docker_password = data.vault_generic_secret.docker.data.password
    })
  ]
}

data "talos_client_configuration" "this" {
  cluster_name         = terraform.workspace
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints = [
    "kube.${local.prefix}.fluence.dev"
  ]
}

resource "digitalocean_droplet" "cp" {
  for_each = { for index, name in local.cp : name => index }

  name      = "rnd-${local.prefix}-spectrum-${each.key}"
  size      = "s-4vcpu-8gb"
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

resource "digitalocean_record" "cp" {
  for_each = { for index, name in local.cp : name => index }

  name   = each.key
  value  = digitalocean_droplet.cp[each.key].ipv4_address
  domain = digitalocean_domain.spectrum.id
  type   = "A"
  ttl    = 30
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = digitalocean_droplet.cp["cp-0"].ipv4_address
  node                 = digitalocean_droplet.cp["cp-0"].ipv4_address
  timeouts = {
    create = "3m"
  }

  lifecycle {
    replace_triggered_by = [
      digitalocean_droplet.cp["cp-0"].id
    ]
  }
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = digitalocean_droplet.cp["cp-0"].ipv4_address
  timeouts = {
    create = "3m"
  }
}

data "talos_cluster_health" "health" {
  client_configuration = data.talos_client_configuration.this.client_configuration
  control_plane_nodes  = [for droplet in digitalocean_droplet.cp : droplet.ipv4_address_private]
  endpoints            = data.talos_client_configuration.this.endpoints
}
