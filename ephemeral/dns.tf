# resource "aws_route53_zone" "dev" {
#   name = "${local.prefix}.example.com"
# }
#
# resource "cloudflare_record" "ns" {
#   for_each = aws_route53_zone.dev.name_servers
#
#   zone_id = data.cloudflare_zone.fluence_dev.zone_id
#   name    = "${local.prefix}.fluence.dev"
#   content = each.key
#   type    = "NS"
# }
