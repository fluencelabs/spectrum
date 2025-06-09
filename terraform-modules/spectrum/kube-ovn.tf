resource "helm_release" "kubeovn" {
  name       = "kubeovn"
  chart      = "kube-ovn"
  repository = "https://kubeovn.github.io/kube-ovn"
  namespace  = "kube-system"
  version    = "1.13.13"
  wait       = true

  values = [
    file("${path.module}/values/kubeovn.yml")
  ]
}

resource "kubectl_manifest" "provider_network" {
  depends_on = [helm_release.kubeovn]
  yaml_body = yamlencode({
    apiVersion = "kubeovn.io/v1"
    kind       = "ProviderNetwork"
    metadata = {
      name = "underlay"
    }
    spec = var.provider_network_spec
  })
}

resource "kubectl_manifest" "nad_public" {
  depends_on = [helm_release.flux-sync]
  yaml_body = yamlencode({
    apiVersion = "k8s.cni.cncf.io/v1"
    kind       = "NetworkAttachmentDefinition"
    metadata = {
      name      = "public"
      namespace = "kube-system"
    }
    spec = {
      config = jsonencode({
        cniVersion    = "0.3.0"
        type          = "kube-ovn"
        server_socket = "/run/openvswitch/kube-ovn-daemon.sock"
        provider      = "public.kube-system.ovn"
      })
    }
  })
}

resource "kubectl_manifest" "vpc" {
  depends_on = [helm_release.kubeovn]
  yaml_body = yamlencode({
    apiVersion = "kubeovn.io/v1"
    kind       = "Vpc"
    metadata = {
      name = "underlay"
    }
  })
}

resource "kubectl_manifest" "vlan" {
  depends_on = [helm_release.kubeovn]
  yaml_body = yamlencode({
    apiVersion = "kubeovn.io/v1"
    kind       = "Vlan"
    metadata = {
      name = tostring(var.vlan)
    }
    spec = {
      id       = var.vlan
      provider = "underlay"
    }
  })
}

resource "kubectl_manifest" "subnets" {
  depends_on = [helm_release.kubeovn]

  for_each = {
    for subnet in var.subnets :
    substr(md5(subnet.cidr), 0, 8) => subnet
  }

  yaml_body = yamlencode({
    apiVersion = "kubeovn.io/v1"
    kind       = "Subnet"
    metadata = {
      name = "subnet-${each.key}"
    }
    spec = {
      vpc                 = "underlay"
      protocol            = "IPv4"
      provider            = "public.kube-system.ovn"
      cidrBlock           = each.value.cidr
      disableGatewayCheck = true
      gateway             = each.value.gateway
      excludeIps          = each.value.excludeIps
      vlan                = tostring(var.vlan)
    }
  })
}
