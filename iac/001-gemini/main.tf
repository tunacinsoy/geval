module "s3_static_website" {
  source  = "tfstack/s3-static-website/aws"
  version = "1.0.5"

  bucket_name = var.bucket_name
  tags        = var.tags

  cdn_enabled         = true
  domain_name         = var.domain_name
  acm_certificate_arn = var.acm_certificate_arn

  # The module can also create a Route 53 record.
  # Assuming the hosted zone already exists in Route 53.
  # If not, it needs to be created separately.
  create_route53_record = true
}
