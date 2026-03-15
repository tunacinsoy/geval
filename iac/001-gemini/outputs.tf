output "website_url" {
  description = "The URL of the static website."
  value       = module.s3_static_website.website_endpoint
}

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution."
  value       = module.s3_static_website.cloudfront_id
}
