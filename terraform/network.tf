data "digitalocean_vpc" "spectrum" {
  name = "rnd-spectrum-vpc"
}

resource "digitalocean_firewall" "spectrum" {
  depends_on = [digitalocean_droplet.cp]

  name = "${local.prefix}-spectrum-firewall"

  tags = [local.prefix]

  inbound_rule {
    protocol = "icmp"
    source_addresses = [
      "0.0.0.0/0", "::/0",
    ]
  }

  inbound_rule {
    protocol   = "tcp"
    port_range = "1-65535"
    source_addresses = [
      "0.0.0.0/0", "::/0",
    ]
  }

  inbound_rule {
    protocol   = "udp"
    port_range = "1-65535"
    source_addresses = [
      "0.0.0.0/0", "::/0",
    ]
  }

  outbound_rule {
    protocol   = "tcp"
    port_range = "1-65535"
    destination_addresses = [
      "0.0.0.0/0", "::/0",
    ]
  }

  outbound_rule {
    protocol   = "udp"
    port_range = "1-65535"
    destination_addresses = [
      "0.0.0.0/0", "::/0",
    ]
  }

  outbound_rule {
    protocol = "icmp"
    destination_addresses = [
      "0.0.0.0/0", "::/0",
    ]
  }
}
