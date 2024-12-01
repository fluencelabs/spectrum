variable "components" {
  type    = list(string)
  default = []
}

variable "network" {
  type    = string
  default = "main"
}

variable "cluster" {
  type    = string
  default = "default"
}

variable "public_ip" {
  type = string
}

variable "cilium_l2_enabled" {
  type    = bool
  default = false
}

variable "cilium_devices" {
  type    = list(string)
  default = []
}

variable "cilium_hubble_enabled" {
  type    = bool
  default = false
}

variable "flux_variables" {
  type    = map(string)
  default = {}
}
