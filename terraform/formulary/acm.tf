resource "aws_acm_certificate" "certificate" {
  domain_name       = "formulary.co"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
