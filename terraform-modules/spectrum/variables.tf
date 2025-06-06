variable "network" {
  type    = string
  default = "main"
}

variable "cluster" {
  type    = string
  default = "default"
}

variable "flux_variables" {
  type    = map(string)
  default = {}
}

variable "provider_network_spec" {
  type = map(string)
}

variable "subnets" {
  type = list(object({
    cidr    = string
    gateway = string
  }))
}
