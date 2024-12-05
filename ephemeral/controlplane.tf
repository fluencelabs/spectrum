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

resource "digitalocean_droplet" "cp" {
  name      = "rnd-${local.prefix}-spectrum-cp"
  size      = "s-4vcpu-8gb"
  image     = data.digitalocean_image.talos.id
  region    = "fra1"
  vpc_uuid  = data.digitalocean_vpc.spectrum.id
  user_data = data.talos_machine_configuration.cp.machine_configuration

  ssh_keys = [
    digitalocean_ssh_key.spectrum.id
  ]

  tags = [
    local.prefix,
    "${local.prefix}-controlplane",
  ]
}

resource "digitalocean_record" "cp" {
  name   = "cp"
  value  = digitalocean_droplet.cp.ipv4_address
  domain = digitalocean_domain.spectrum.id
  type   = "A"
  ttl    = 30
}

resource "digitalocean_reserved_ip" "l2" {
  droplet_id = digitalocean_droplet.cp.id
  region     = digitalocean_droplet.cp.region
}

resource "talos_machine_secrets" "this" {
  talos_version = "v1.8"
}

data "talos_machine_configuration" "cp" {
  cluster_name     = terraform.workspace
  machine_type     = "controlplane"
  cluster_endpoint = "https://${local.loadbalancer_dns}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  talos_version    = "v1.8"
  config_patches = [
    templatefile("${path.module}/templates/controlplane_patch.yml", {
      loadbalancerdns = "kube.${local.prefix}.fluence.dev"
      hostdns         = "cp.${local.prefix}.fluence.dev",
      subnet          = data.digitalocean_vpc.spectrum.ip_range,
      docker_username = data.vault_generic_secret.docker.data.username
      docker_password = data.vault_generic_secret.docker.data.password
    })
  ]
}

resource "talos_machine_configuration_apply" "this" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.cp.machine_configuration
  node                        = digitalocean_droplet.cp.ipv4_address
}

data "talos_client_configuration" "this" {
  cluster_name         = terraform.workspace
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints = [
    "kube.${local.prefix}.fluence.dev"
  ]
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = digitalocean_droplet.cp.ipv4_address
  node                 = digitalocean_droplet.cp.ipv4_address
  timeouts = {
    create = "3m"
  }

  lifecycle {
    replace_triggered_by = [
      digitalocean_droplet.cp.id
    ]
  }
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = digitalocean_droplet.cp.ipv4_address
  timeouts = {
    create = "3m"
  }
}

data "http" "talos_health" {
  url      = "https://${digitalocean_record.endpoint.fqdn}:6443/version"
  insecure = true
  retry {
    attempts     = 20
    min_delay_ms = 5000
    max_delay_ms = 5000
  }
  depends_on = [
    talos_machine_bootstrap.this,
  ]
}
