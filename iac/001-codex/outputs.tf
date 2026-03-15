output "asset_bucket" {
  value       = aws_s3_bucket.assets.bucket
  description = "Bucket hosting the static assets"
}

output "distribution_domain" {
  value       = aws_cloudfront_distribution.site.domain_name
  description = "CloudFront domain that serves the site"
}

output "public_endpoint" {
  value       = aws_route53_record.site_root.fqdn
  description = "Primary DNS entry for the site"
}
