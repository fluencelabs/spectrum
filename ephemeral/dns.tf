resource "aws_route53_zone" "dev" {
  name = "${local.prefix}.example.com"
}

resource "cloudflare_record" "ns" {
  for_each = aws_route53_zone.dev.name_servers

  zone_id = data.cloudflare_zone.fluence_dev.zone_id
  name    = "${local.prefix}.fluence.dev"
  content = each.key
  type    = "NS"
}

resource "digitalocean_record" "endpoint" {
  domain = digitalocean_domain.spectrum.id
  type   = "A"
  name   = "kube"
  value  = digitalocean_loadbalancer.cp.ip
  ttl    = 30
}

resource "aws_route53_record" "endpoint" {
  zone_id = aws_route53_zone.dev.zone_id
  name    = "kube"
  type    = "A"
  ttl     = 0
  # records = [aws_eip.lb.public_ip]
}

resource "digitalocean_record" "cp" {
  name   = "cp"
  value  = digitalocean_droplet.cp.ipv4_address
  domain = digitalocean_domain.spectrum.id
  type   = "A"
  ttl    = 30
}
