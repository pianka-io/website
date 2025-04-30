resource "aws_route53_zone" "pianka_io" {
  name = "pianka.io"
}

resource "aws_route53_record" "google_workspace_txt" {
  zone_id = aws_route53_zone.pianka_io.zone_id
  name    = ""
  type    = "TXT"
  ttl     = "300"
  records = ["google-site-verification=uSf9ThHvSXm0L4YaQbxJF6BMiIYS7cuDU00oTsmPRRo"]
}

resource "aws_route53_record" "google_workspace_mx" {
  zone_id = aws_route53_zone.pianka_io.zone_id
  name    = ""
  type    = "MX"
  ttl     = "300"
  records = ["10 smtp.google.com"]
}

resource "aws_route53_record" "naked" {
  zone_id = aws_route53_zone.pianka_io.zone_id
  name    = "pianka.io"
  type    = "A"

  alias {
    name                   = var.domain_name
    zone_id                = var.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "warnet" {
  allow_overwrite = true
  name            = "war.pianka.io"
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.pianka_io.zone_id

  records = [
    "ns-1259.awsdns-29.org.",
    "ns-833.awsdns-40.net.",
    "ns-341.awsdns-42.com.",
    "ns-1880.awsdns-43.co.uk."
  ]
}
