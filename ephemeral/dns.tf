resource "cloudflare_record" "ns" {
  for_each = toset([
    "ns1.digitalocean.com",
    "ns2.digitalocean.com",
    "ns3.digitalocean.com",
  ])

  zone_id = data.cloudflare_zone.fluence_dev.zone_id
  name    = "${local.prefix}.fluence.dev"
  content = each.key
  type    = "NS"
}

resource "digitalocean_domain" "spectrum" {
  depends_on = [cloudflare_record.ns]
  name       = "${local.prefix}.fluence.dev"
}
