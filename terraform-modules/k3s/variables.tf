variable "kubeconfigs_location" {
  default = "./secrets"
}

variable "server_name" {
}

variable "server_ip_address" {
}

variable "ssh_key" {
}

variable "ssh_port" {
  default = "22"
}

variable "ssh_user" {
  default = "root"
}
