resource "helm_release" "cilium" {
  name       = "cilium"
  chart      = "cilium"
  repository = "https://helm.cilium.io/"
  namespace  = "kube-system"
  version    = "1.16.4"

  values = [
    templatefile("${path.module}/cilium-values.yml", {
      l2_enabled     = var.cilium.l2.enabled,
      devices      = var.cilium.l2.devices
      hubble_enabled = var.cilium.hubble
    })
  ]
}
