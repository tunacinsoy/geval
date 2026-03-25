output "cloudfront_domain" {
  value       = aws_cloudfront_distribution.cdn.domain_name
  description = "Primary CloudFront distribution domain"
}

output "primary_bucket" {
  value       = aws_s3_bucket.primary.bucket_domain_name
  description = "Primary origin bucket"
}

output "failover_bucket" {
  value       = aws_s3_bucket.failover.bucket_domain_name
  description = "Failover S3 bucket"
}
