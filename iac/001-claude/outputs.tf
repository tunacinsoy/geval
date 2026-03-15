# Terraform Outputs - Infrastructure Values for Deployment and Verification

output "s3_bucket_name" {
  description = "Primary S3 bucket name for website content"
  value       = aws_s3_bucket.website.id
}

output "s3_bucket_arn" {
  description = "Primary S3 bucket ARN"
  value       = aws_s3_bucket.website.arn
}

output "s3_logging_bucket_name" {
  description = "S3 bucket name for access logs"
  value       = aws_s3_bucket.logging.id
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (use for cache invalidation)"
  value       = aws_cloudfront_distribution.website.id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name (e.g., d1234567890.cloudfront.net)"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.website.arn
}

output "route53_zone_id" {
  description = "Route53 hosted zone ID for the custom domain"
  value       = aws_route53_zone.website.zone_id
}

output "route53_nameservers" {
  description = "Route53 nameservers (update domain registrar if needed)"
  value       = aws_route53_zone.website.name_servers
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN (for HTTPS)"
  value       = aws_acm_certificate.website.arn
}

output "cloudwatch_dashboard_url" {
  description = "CloudWatch dashboard URL for monitoring"
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.website.dashboard_name}"
}

output "website_url" {
  description = "Website URL (HTTPS with custom domain)"
  value       = "https://${var.domain_name}"
}

output "deployment_instructions" {
  description = "Instructions for uploading website content to S3"
  value       = <<-EOT
    To upload website content to S3:

    1. Using AWS CLI:
       aws s3 sync ./website-content/ s3://${aws_s3_bucket.website.id}/ --delete

    2. Using AWS Management Console:
       https://${var.aws_region}.console.aws.amazon.com/s3/buckets/${aws_s3_bucket.website.id}

    3. Invalidate CloudFront cache after updates:
       aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.website.id} --paths "/*"
  EOT
}
