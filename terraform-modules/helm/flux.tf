resource "helm_release" "flux" {
  depends_on = [helm_release.cilium]
  name             = "flux"
  chart            = "flux2"
  repository       = "https://fluxcd-community.github.io/helm-charts/"
  namespace        = "flux-system"
  create_namespace = "true"
  wait             = "true"

  set {
    name  = "notificationController.create"
    value = "false"
  }

  set {
    name  = "imageReflectionController.create"
    value = "false"
  }

  set {
    name  = "imageAutomationController.create"
    value = "false"
  }
}

resource "helm_release" "flux-sync" {
  depends_on = [helm_release.flux]
  name       = "spectrum"
  chart      = "flux2-sync"
  repository = "https://fluxcd-community.github.io/helm-charts/"
  namespace  = "flux-system"
  wait       = true

  set {
    name  = "gitRepository.spec.url"
    value = "https://github.com/fluencelabs/spectrum.git"
  }

  set {
    name  = "gitRepository.spec.interval"
    value = "1m"
  }

  set {
    name  = "gitRepository.spec.ref.branch"
    value = var.network
  }

  set {
    name  = "kustomization.spec.interval"
    value = "1m0s"
  }

  set {
    name  = "kustomization.spec.path"
    value = "./flux/clusters/default"
  }

  set {
    name  = "kustomization.spec.validation"
    value = "client"
  }
}
