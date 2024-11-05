terraform {
  backend "s3" {
    bucket = "spectrum-ci"
    key    = "state"
    region = "eu-west-1"
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4"
    }
    talos = {
      source = "siderolabs/talos"
    }
  }
}

data "cloudflare_zone" "fluence_dev" {
  name = "fluence.dev"
}

provider "vault" {
  address = "https://hashi.fluence.dev:8200"
}
