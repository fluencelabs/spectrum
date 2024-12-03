output "kubeconfig_file" {
  description = "kubeconfig file location"
  value       = "${terraform_data.k3s-gen-kubeconfig.input}"
}
