module "distribution" {
  source = "./cloudfront"

  bucket_id                   = aws_s3_bucket.bucket.id
  bucket_arn                  = aws_s3_bucket.bucket.arn
  bucket_regional_domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
  website_endpoint            = aws_s3_bucket_website_configuration.website.website_endpoint
  certificate_arn             = aws_acm_certificate.certificate.arn
}
