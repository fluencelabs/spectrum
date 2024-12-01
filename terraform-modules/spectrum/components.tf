data "kubectl_filename_list" "components" {
  pattern = "./components/*.yml"
}

resource "kubectl_manifest" "components" {
  depends_on = [helm_release.flux]
  for_each = {
    for file in data.kubectl_filename_list.components.matches :
    file => file if contains(var.components, replace(basename(file), ".yml", ""))
  }
  yaml_body = file(each.value)
}
