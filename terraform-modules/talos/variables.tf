variable "public_ip" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "components" {
  type = list(string)
}

variable "network" {
  type = string
}
