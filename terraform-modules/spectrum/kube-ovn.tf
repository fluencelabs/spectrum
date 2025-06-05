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
