terraform {
  backend "s3" {
    bucket = "pianka-io-website-tf"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "bucket" {
  source = "./modules/s3"
  name   = "pianka-io-website-hugo"
}

module "distribution" {
  source = "./modules/cloudfront"

  bucket_id                   = module.bucket.bucket_id
  bucket_arn                  = module.bucket.bucket_arn
  bucket_regional_domain_name = module.bucket.bucket_regional_domain_name
  website_endpoint            = module.bucket.website_endpoint
  certificate_arn             = module.tls.certificate_arn
}

module "tls" {
  source = "./modules/acm"
}

module "dns" {
  source = "./modules/route53"

  certificate_arn                     = module.tls.certificate_arn
  domain_validation_options           = module.tls.domain_validation_options
  domain_name                         = module.distribution.domain_name
  zone_id                             = module.distribution.zone_id
}