# Main Infrastructure Resources - Flower Shop Static Website

# ============================================================================
# Phase 2: Storage & Access Control
# ============================================================================

# Primary S3 bucket for website content
resource "aws_s3_bucket" "website" {
  bucket_prefix = "flower-shop-website-"

  tags = {
    Name = "Website Content Bucket"
  }
}

# Logging S3 bucket for CloudFront and S3 access logs
resource "aws_s3_bucket" "logging" {
  bucket_prefix = "flower-shop-logs-"

  tags = {
    Name = "Access Logs Bucket"
  }
}

# Block public access to primary bucket (CloudFront will access via OAI)
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block public access to logging bucket
resource "aws_s3_bucket_public_access_block" "logging" {
  bucket = aws_s3_bucket.logging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning on primary bucket for rollback capability
resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id

  versioning_configuration {
    status = var.s3_bucket_versioning_enabled ? "Enabled" : "Suspended"
  }
}

# Enable versioning on logging bucket for log history
resource "aws_s3_bucket_versioning" "logging" {
  bucket = aws_s3_bucket.logging.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption on primary bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable server-side encryption on logging bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "logging" {
  bucket = aws_s3_bucket.logging.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable S3 access logging on primary bucket
resource "aws_s3_bucket_logging" "website" {
  bucket = aws_s3_bucket.website.id

  target_bucket = aws_s3_bucket.logging.id
  target_prefix = "s3-access-logs/"
}

# CloudFront Origin Access Identity (OAI) for secure bucket access
resource "aws_cloudfront_origin_access_identity" "website" {
  comment = "OAI for flower shop website"
}

# S3 bucket policy to allow CloudFront access only
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontAccess"
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.website.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.website.arn}/*"
      },
      {
        Sid    = "AllowCloudFrontListBucket"
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.website.iam_arn
        }
        Action   = "s3:ListBucket"
        Resource = aws_s3_bucket.website.arn
      }
    ]
  })
}

# S3 lifecycle rule to manage versions
resource "aws_s3_bucket_lifecycle_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    id     = "DeleteOldVersions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

# S3 lifecycle rule for logs
resource "aws_s3_bucket_lifecycle_configuration" "logging" {
  bucket = aws_s3_bucket.logging.id

  rule {
    id     = "ArchiveOldLogs"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}

# ============================================================================
# Phase 3: CloudFront & DNS
# ============================================================================

# CloudFront distribution for global content delivery
resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = "S3Origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.website.cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100" # Use only NA, Europe, Asia-Pacific

  # Default cache behavior for HTML content
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    cache_policy_id = data.aws_cloudfront_cache_policy.managed_caching_optimized.id

    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.managed_all_viewer.id

    compress         = true
    smooth_streaming = false

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.index_redirect.arn
    }
  }

  # Cache behavior for images and assets (1 year TTL)
  cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    cache_policy_id = data.aws_cloudfront_cache_policy.managed_caching_long_ttl.id
    compress        = true
  }

  # Cache behavior for CSS and JavaScript (1 year TTL with versioning)
  cache_behavior {
    path_pattern     = "/css/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    cache_policy_id = data.aws_cloudfront_cache_policy.managed_caching_long_ttl.id
    compress        = true
  }

  cache_behavior {
    path_pattern     = "/js/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    cache_policy_id = data.aws_cloudfront_cache_policy.managed_caching_long_ttl.id
    compress        = true
  }

  # Custom error responses
  custom_error_response {
    error_code            = 404
    error_caching_min_ttl = 300
    response_code         = 404
    response_page_path    = "/404.html"
  }

  custom_error_response {
    error_code            = 403
    error_caching_min_ttl = 300
    response_code         = 404
    response_page_path    = "/404.html"
  }

  # HTTPS with certificate
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.website.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # Custom domain alias
  aliases = [var.domain_name]

  # Access logging
  dynamic "logging_config" {
    for_each = var.enable_logging ? [1] : []
    content {
      include_cookies = false
      bucket          = aws_s3_bucket.logging.bucket_regional_domain_name
      prefix          = "cloudfront-logs/"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "Website CloudFront Distribution"
  }

  depends_on = [aws_acm_certificate_validation.website]
}

# CloudFront function to redirect /folder to /folder/index.html
resource "aws_cloudfront_function" "index_redirect" {
  name    = "flower-shop-index-redirect"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file("${path.module}/cloudfront-function.js")
}

# Route53 hosted zone for the domain
resource "aws_route53_zone" "website" {
  name = var.domain_name

  tags = {
    Name = "Website Hosted Zone"
  }
}

# Route53 A record pointing to CloudFront
resource "aws_route53_record" "website_a" {
  zone_id = aws_route53_zone.website.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

# Route53 AAAA record (IPv6) pointing to CloudFront
resource "aws_route53_record" "website_aaaa" {
  zone_id = aws_route53_zone.website.zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

# ACM certificate for HTTPS
resource "aws_acm_certificate" "website" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Website Certificate"
  }
}

# ACM certificate validation records in Route53
resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.website.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.website.zone_id
}

resource "aws_acm_certificate_validation" "website" {
  certificate_arn = aws_acm_certificate.website.arn

  timeouts {
    create = "5m"
  }

  depends_on = [aws_route53_record.acm_validation]
}

# ============================================================================
# Phase 4: Monitoring & Logging
# ============================================================================

# CloudWatch dashboard for monitoring
resource "aws_cloudwatch_dashboard" "website" {
  count = var.enable_monitoring ? 1 : 0

  dashboard_name = "flower-shop-website"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/CloudFront", "Requests", { stat = "Sum", label = "Total Requests" }],
            ["AWS/CloudFront", "BytesDownloaded", { stat = "Sum", label = "Bytes Downloaded" }],
            ["AWS/CloudFront", "4xxErrorRate", { stat = "Average", label = "4xx Error Rate %" }],
            ["AWS/CloudFront", "5xxErrorRate", { stat = "Average", label = "5xx Error Rate %" }],
            ["AWS/CloudFront", "CacheHitRate", { stat = "Average", label = "Cache Hit Rate %" }]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "CloudFront Metrics"
        }
      },
      {
        type = "log"
        properties = {
          query  = "fields @timestamp, cs_uri_stem, cs_status, cs_bytes | stats count() by cs_status"
          region = var.aws_region
          title  = "CloudFront Error Distribution"
        }
      }
    ]
  })

  depends_on = [aws_cloudfront_distribution.website]
}

# CloudWatch alarms
resource "aws_cloudwatch_metric_alarm" "cloudfront_5xx_errors" {
  count = var.enable_monitoring ? 1 : 0

  alarm_name          = "flower-shop-cloudfront-5xx-errors"
  alarm_description   = "Alert when CloudFront 5xx error rate is high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "5xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = "300"
  statistic           = "Average"
  threshold           = "1.0"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DistributionId = aws_cloudfront_distribution.website.id
  }
}

resource "aws_cloudwatch_metric_alarm" "cloudfront_4xx_errors" {
  count = var.enable_monitoring ? 1 : 0

  alarm_name          = "flower-shop-cloudfront-4xx-errors"
  alarm_description   = "Alert when CloudFront 4xx error rate is high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "4xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = "300"
  statistic           = "Average"
  threshold           = "5.0"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DistributionId = aws_cloudfront_distribution.website.id
  }
}

resource "aws_cloudwatch_metric_alarm" "cloudfront_cache_hit_rate" {
  count = var.enable_monitoring ? 1 : 0

  alarm_name          = "flower-shop-cloudfront-cache-hit-rate"
  alarm_description   = "Alert when CloudFront cache hit rate is low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CacheHitRate"
  namespace           = "AWS/CloudFront"
  period              = "300"
  statistic           = "Average"
  threshold           = "80.0"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DistributionId = aws_cloudfront_distribution.website.id
  }
}

# SNS topic for alarm notifications
resource "aws_sns_topic" "website_alerts" {
  count = var.enable_monitoring ? 1 : 0

  name_prefix = "flower-shop-website-"

  tags = {
    Name = "Website Alerts"
  }
}

# SNS topic subscription for email (requires manual subscription confirmation)
# To subscribe: uncomment this and update the email_address
resource "aws_sns_topic_subscription" "website_alerts_email" {
  count = var.enable_monitoring ? 0 : 0 # Change to 1 to enable email notifications

  topic_arn = aws_sns_topic.website_alerts[0].arn
  protocol  = "email"
  endpoint  = "your-email@example.com" # CHANGE THIS to your email
}

# Attach SNS topic to alarms
resource "aws_cloudwatch_metric_alarm" "cloudfront_5xx_errors_with_sns" {
  count = var.enable_monitoring ? 1 : 0

  alarm_name          = "flower-shop-cloudfront-5xx-errors-with-sns"
  alarm_description   = "Alert when CloudFront 5xx error rate is high (with SNS)"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "5xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = "300"
  statistic           = "Average"
  threshold           = "1.0"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.website_alerts[0].arn]

  dimensions = {
    DistributionId = aws_cloudfront_distribution.website.id
  }
}

# ============================================================================
# Data Sources
# ============================================================================

# Managed cache policies
data "aws_cloudfront_cache_policy" "managed_caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "managed_caching_long_ttl" {
  name = "Managed-CachingDisabled" # Will use custom TTL
}

data "aws_cloudfront_origin_request_policy" "managed_all_viewer" {
  name = "Managed-AllViewerExceptHostHeader"
}
