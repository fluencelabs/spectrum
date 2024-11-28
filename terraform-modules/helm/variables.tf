variable "components" {
  type = list(string)
}

variable "network" {
  type    = string
  default = "main"
}

variable "kubeconfig_path" {
  type = string
}

variable "cilium" {
  type = object({
    l2 = object({
      enabled = bool
      devices = list(string)
    })
    hubble = object({
      enabled = bool
    })
  })

  default = {
    l2 = {
      enabled = false
      devices = []
    }
    hubble = {
      enabled = false
    }
  }

  validation {
    condition     = !(var.cilium.l2.enabled && length(var.cilium.l2.devices) == 0)
    error_message = "If 'l2.enabled' is true, 'devices' must not be empty."
  }

  description = "Configuration for Cilium."
}
