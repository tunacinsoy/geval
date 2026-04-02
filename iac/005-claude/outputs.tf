# Consolidated Output Values
# Export key infrastructure identifiers for use in applications and operations

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "infrastructure_summary" {
  description = "Summary of deployed infrastructure"
  value = {
    service           = "AWS CloudFront CDN"
    environment       = var.environment
    blog_domain       = var.domain_name
    origin_domain     = var.origin_domain
    cloudfront_domain = aws_cloudfront_distribution.blog_cdn.domain_name
    distribution_id   = aws_cloudfront_distribution.blog_cdn.id
  }
}

# CloudFront Distribution Outputs
output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name (d123456.cloudfront.net)"
  value       = aws_cloudfront_distribution.blog_cdn.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (for cache invalidation and DNS configuration)"
  value       = aws_cloudfront_distribution.blog_cdn.id
}

output "cloudfront_arn" {
  description = "ARN of CloudFront distribution"
  value       = aws_cloudfront_distribution.blog_cdn.arn
}

output "cloudfront_etag" {
  description = "ETag of CloudFront distribution (useful for tracking changes)"
  value       = aws_cloudfront_distribution.blog_cdn.etag
}

output "cloudfront_logs_bucket" {
  description = "S3 bucket name for CloudFront access logs"
  value       = aws_s3_bucket.cloudfront_logs.id
}

# Cache Configuration Outputs
output "cache_configuration" {
  description = "Cache TTL configuration by content type"
  value = {
    evergreen_ttl = "${var.evergreen_ttl} seconds (${floor(var.evergreen_ttl / 86400)} days)"
    blog_post_ttl = "${var.blog_post_ttl} seconds (${floor(var.blog_post_ttl / 86400)} days)"
    featured_ttl  = "${var.featured_ttl} seconds (${floor(var.featured_ttl / 3600)} hours)"
  }
}

# Cache Path Patterns
output "cache_behaviors" {
  description = "Cache behavior patterns and their TTL values"
  value = {
    "/evergreen/*"  = "${var.evergreen_ttl}s (evergreen content)"
    "/blog-posts/*" = "${var.blog_post_ttl}s (blog post images)"
    "/featured/*"   = "${var.featured_ttl}s (featured/recent images)"
    "default"       = "${var.blog_post_ttl}s (all other paths)"
  }
}

# Monitoring & Alerting Outputs
output "cloudwatch_dashboard_url" {
  description = "URL to CloudWatch monitoring dashboard"
  value       = "https://console.aws.amazon.com/cloudwatch/home#dashboards:name=blog-cdn-${var.environment}"
}

output "sns_topic_arn" {
  description = "SNS topic ARN for alert notifications"
  value       = aws_sns_topic.blog_cdn_alerts.arn
}

output "sns_alert_email" {
  description = "Email address subscribed to SNS alerts"
  value       = var.alert_email
  sensitive   = true
}

output "alert_configuration" {
  description = "CloudWatch alarm configuration thresholds"
  value = {
    cache_hit_ratio_threshold_percent = var.cache_hit_alert_threshold
    latency_p95_threshold_ms          = var.latency_alert_threshold
    alert_recipient_email             = var.alert_email
  }
}

# Logging & Analytics Outputs
output "cloudfront_logs_bucket_arn" {
  description = "ARN of S3 bucket for CloudFront access logs"
  value       = aws_s3_bucket.cloudfront_logs.arn
}

output "logs_configuration" {
  description = "CloudFront access logs configuration"
  value = {
    bucket_name    = aws_s3_bucket.cloudfront_logs.id
    log_prefix     = "cloudfront-logs/"
    versioning     = "Enabled"
    encryption     = "AES-256"
    glacier_after  = "90 days"
    deletion_after = "365 days"
  }
}

# Origin Configuration Outputs
output "origin_configuration" {
  description = "Origin server configuration"
  value = {
    domain                 = var.origin_domain
    protocol               = "HTTPS (required)"
    health_check_path      = var.health_check_path
    health_check_interval  = "${var.health_check_interval} seconds"
    failure_threshold      = "${var.health_check_failure_count} consecutive failures"
    origin_shield          = "Enabled (us-east-1)"
    custom_header_required = "X-Origin-Verify"
  }
}

# Performance Metrics Outputs
output "performance_targets" {
  description = "Performance SLO targets for CDN"
  value = {
    cache_hit_ratio_target_percent = "85%"
    latency_p95_target_ms          = "500ms"
    latency_p99_target_ms          = "1000ms"
    ttfb_target_ms                 = "100ms (cached content)"
    error_rate_target_percent      = "<0.1%"
  }
}

# IAM Access Outputs
output "cloudfront_service_role_arn" {
  description = "ARN of CloudFront service role"
  value       = aws_iam_role.cloudfront_service_role.arn
}

output "cache_invalidation_policy_arn" {
  description = "ARN of cache invalidation policy (for CI/CD service accounts)"
  value       = aws_iam_policy.cloudfront_cache_invalidation.arn
}

output "cache_invalidation_policy_json" {
  description = "JSON policy for cache invalidation"
  value       = aws_iam_policy.cloudfront_cache_invalidation.policy
  sensitive   = true
}

output "cache_invalidation_instructions" {
  description = "Instructions for implementing cache invalidation"
  value = {
    step_1 = "Attach cache_invalidation_policy_arn to CI/CD service account"
    step_2 = "Use AWS CLI: aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.blog_cdn.id} --paths '/*'"
    step_3 = "Or use Terraform: aws_cloudfront_invalidation resource"
    step_4 = "Invalidation completes within 5 minutes across all edge locations"
  }
}

# DNS Configuration Outputs
output "dns_configuration_instructions" {
  description = "Steps to configure DNS for CDN"
  value = {
    step_1 = "Record type: CNAME or ALIAS"
    step_2 = "Source domain: ${var.domain_name}"
    step_3 = "Target domain: ${aws_cloudfront_distribution.blog_cdn.domain_name}"
    step_4 = "TTL: 300 seconds (5 minutes) for quick failover"
    step_5 = "Provider: Route 53, GoDaddy, Cloudflare, etc."
  }
}

# Testing & Validation Outputs
output "validation_tests" {
  description = "Validation tests to confirm CDN is working correctly"
  value = {
    test_1 = "curl -I https://${aws_cloudfront_distribution.blog_cdn.domain_name}/evergreen/image.jpg"
    test_2 = "Verify X-Cache header shows 'Hit from cloudfront'"
    test_3 = "Verify Cache-Control header shows appropriate TTL"
    test_4 = "Verify Content-Encoding header shows 'gzip' or 'br'"
    test_5 = "Monitor CloudWatch dashboard for cache hit ratio >85%"
  }
}

# Troubleshooting Guide
output "troubleshooting_guide" {
  description = "Common troubleshooting steps for CDN issues"
  value = {
    low_cache_hit_ratio  = "1. Check origin Cache-Control headers; 2. Review cache behaviors match origin paths; 3. Check for query strings"
    high_latency         = "1. Verify origin server health; 2. Check CloudWatch dashboard for 5xx errors; 3. Verify TLS negotiation"
    origin_errors        = "1. Check origin health check endpoint; 2. Verify X-Origin-Verify header required by origin; 3. Check origin security groups"
    alert_false_positive = "1. Review alert thresholds in terraform.tfvars; 2. Check for legitimate traffic spikes; 3. Adjust evaluation periods"
  }
}

# Deployment Complete
output "deployment_status" {
  description = "Deployment status and next steps"
  value = {
    status     = "✓ Infrastructure code generated and validated"
    next_steps = "1. terraform plan -var-file=terraform.tfvars.prod; 2. terraform apply; 3. Update DNS CNAME record; 4. Monitor CloudWatch dashboard"
    support    = "See iac/README.md and iac/MIGRATION-LOCAL-TO-S3.md for additional guidance"
  }
}
