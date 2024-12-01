locals {
  invalid_l2_configuration = var.cilium_l2_enabled && length(var.cilium_devices) == 0
}

resource "null_resource" "validate_l2_config" {
  count = local.invalid_l2_configuration ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'Validation failed: If cilium_l2_enabled is true, cilium_devices must not be empty.'; exit 1"
  }
}

data "http" "health" {
  url      = "https://${var.public_ip}:6443/version"
  insecure = true
  retry {
    attempts     = 60
    min_delay_ms = 5000
    max_delay_ms = 5000
  }
}

resource "helm_release" "cilium" {
  depends_on = [data.http.health]
  name       = "cilium"
  chart      = "cilium"
  repository = "https://helm.cilium.io/"
  namespace  = "kube-system"
  version    = "1.16.4"
  wait       = true

  values = [
    templatefile("${path.module}/templates/cilium.yml", {
      l2_enabled     = var.cilium_l2_enabled,
      devices        = var.cilium_devices
      hubble_enabled = var.cilium_hubble_enabled
    })
  ]
}
