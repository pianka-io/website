resource "aws_route53_zone" "formulary_co" {
  name = "formulary.co"
}

resource "aws_route53_record" "google_workspace_txt" {
  zone_id = aws_route53_zone.formulary_co.zone_id
  name    = ""
  type    = "TXT"
  ttl     = "300"
  records = ["google-site-verification=mrDz-GkNYaDBOEudRpWLrnGHNNua5rAFQe7ukR1tQOo"]
}

resource "aws_route53_record" "google_workspace_mx" {
  zone_id = aws_route53_zone.formulary_co.zone_id
  name    = ""
  type    = "MX"
  ttl     = "300"
  records = ["10 smtp.google.com"]
}

resource "aws_route53_record" "tls" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.formulary_co.zone_id
}

resource "aws_acm_certificate_validation" "formulary_co" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.tls : record.fqdn]
}

resource "aws_route53_record" "naked" {
  zone_id = aws_route53_zone.formulary_co.zone_id
  name    = "formulary.co"
  type    = "A"

  alias {
    name                   = module.distribution.domain_name
    zone_id                = module.distribution.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "allen_formulary_a" {
  zone_id = aws_route53_zone.formulary_co.zone_id
  name    = "allen.formulary.co"
  type    = "A"
  ttl     = 300
  records = ["32.218.94.46"]
}

resource "aws_route53_record" "certbot" {
  zone_id = aws_route53_zone.formulary_co.zone_id
  name    = "_acme-challenge.allen.formulary.co."
  type    = "TXT"
  ttl     = "300"
  records = ["B1uJnth_6qG3UpFzYyQHn_MCKfbmxRrNdFhPIJdT470"]
}
