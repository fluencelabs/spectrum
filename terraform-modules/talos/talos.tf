resource "talos_machine_secrets" "this" {
  talos_version = "v1.8"
}

data "talos_machine_configuration" "this" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = "https://${var.public_ip}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  talos_version    = "v1.8"
  config_patches = [
    templatefile("${path.module}/templates/controlplane_patch.yml", {})
  ]
}

resource "talos_machine_configuration_apply" "this" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this.machine_configuration
  node                        = var.public_ip
  config_patches              = var.config_patches
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints = [
    var.public_ip
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on           = [talos_machine_configuration_apply.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = var.public_ip
  node                 = var.public_ip
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.public_ip
}

data "talos_cluster_health" "this" {
  client_configuration   = data.talos_client_configuration.this.client_configuration
  control_plane_nodes    = [var.public_ip]
  endpoints              = data.talos_client_configuration.this.endpoints
  skip_kubernetes_checks = true
}
