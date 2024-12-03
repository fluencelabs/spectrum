resource "terraform_data" "k3s-init" {

  input = var.server_name
  provisioner "local-exec" {
    command = <<EOT
        autok3s create --provider  native --docker-script  https://get.docker.com --k3s-channel  stable --k3s-install-script  https://get.k3s.io \
        --master-extra-args '--disable servicelb,traefik --flannel-backend none --disable-kube-proxy --disable-network-policy' \
        --name ${var.server_name} --rollback --ssh-key-path ${var.ssh_key} --ssh-port ${var.ssh_port} --ssh-user ${var.ssh_user} --master-ips ${var.server_ip_address} \
        --enable explorer
    EOT

  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
        autok3s delete -p native --name ${self.input} -f
    EOT

  }
}

resource "terraform_data" "k3s-gen-kubeconfig" {
  depends_on = [
    terraform_data.k3s-init
  ]
  input = "${var.kubeconfigs_location}/kubeconfig.yaml"
  provisioner "local-exec" {
    command = <<EOT
        mkdir -p ${var.kubeconfigs_location} && \
        autok3s kubectl config use-context ${var.server_name} && \
        autok3s kubectl config view --minify=true --raw > ${var.kubeconfigs_location}/kubeconfig.yaml
    EOT

  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
        rm -rf ${self.input}.yaml
    EOT

  }
}

resource "terraform_data" "os-init" {

  connection {
    type        = "ssh"
    user        = var.ssh_user
    port        = var.ssh_port
    private_key = file(var.ssh_key)
    host        = var.server_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash"
    ]
  }
}
