variable "server_ip" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "config_patches" {
  type    = list(string)
  default = []
}
