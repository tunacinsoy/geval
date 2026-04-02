# AWS CloudFront Distribution for Blog Image Delivery
# Globally distributed CDN with tiered caching (30/7/1 day TTLs)
# Image compression and format negotiation enabled

resource "aws_cloudfront_distribution" "blog_cdn" {
  web_acl_id = aws_wafv2_web_acl.blog_cdn_waf.arn
  origin {
    domain_name = var.origin_domain
    origin_id   = "blog-origin"

    # Origin configuration
    origin_shield {
      enabled              = true
      origin_shield_region = "us-east-1"
    }

    # Custom header for origin security
    custom_header {
      name  = "X-Origin-Verify"
      value = var.origin_verify_token
    }

    custom_header {
      name  = "User-Agent"
      value = "CloudFront"
    }

    # HTTPS-only origin connectivity
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Note: origin_group requires multiple members for failover.
  # For single-origin setup, health checks handled via origin configuration.

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for blog image delivery"
  default_root_object = ""

  # Default cache behavior (catch-all for non-matching paths)
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "blog-origin"

    # Cache control and compression
    compress = var.enable_compression

    # Viewer protocol policy: HTTPS only
    viewer_protocol_policy = "redirect-to-https"

    # Cache TTL settings
    min_ttl     = 0
    default_ttl = var.blog_post_ttl # Default to blog post TTL for unmatched paths
    max_ttl     = 31536000          # 1 year

    # Cache based on headers and query strings
    forwarded_values {
      query_string = false
      headers      = ["Accept", "Accept-Encoding"]

      cookies {
        forward = "none"
      }
    }

    # CloudFront managed caching policy
    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.add_security_headers.arn
    }
  }

  # Cache behavior for evergreen images (30-day TTL)
  ordered_cache_behavior {
    path_pattern     = "/evergreen/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "blog-origin"

    compress = var.enable_compression

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = var.evergreen_ttl
    max_ttl     = 31536000

    forwarded_values {
      query_string = false
      headers      = ["Accept", "Accept-Encoding"]

      cookies {
        forward = "none"
      }
    }

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.add_security_headers.arn
    }
  }

  # Cache behavior for blog post images (7-day TTL)
  ordered_cache_behavior {
    path_pattern     = "/blog-posts/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "blog-origin"

    compress = var.enable_compression

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = var.blog_post_ttl
    max_ttl     = 31536000

    forwarded_values {
      query_string = false
      headers      = ["Accept", "Accept-Encoding"]

      cookies {
        forward = "none"
      }
    }

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.add_security_headers.arn
    }
  }

  # Cache behavior for featured images (1-day TTL)
  ordered_cache_behavior {
    path_pattern     = "/featured/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "blog-origin"

    compress = var.enable_compression

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = var.featured_ttl
    max_ttl     = 31536000

    forwarded_values {
      query_string = false
      headers      = ["Accept", "Accept-Encoding"]

      cookies {
        forward = "none"
      }
    }

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.add_security_headers.arn
    }
  }

  # Restrictions (no geographic restrictions)
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Viewer certificate configuration
  viewer_certificate {
    cloudfront_default_certificate = true
    # For custom domain: acm_certificate_arn + aliases
  }

  # Access logging to S3
  dynamic "logging_config" {
    for_each = var.enable_logging ? [1] : []

    content {
      include_cookies = false
      bucket          = aws_s3_bucket.cloudfront_logs.bucket_domain_name
      prefix          = "cloudfront-logs/"
    }
  }

  # HTTP/2 and HTTP/3 support
  http_version = "http2and3"
  price_class = "PriceClass_200"

  depends_on = [
    aws_cloudfront_function.add_security_headers,
    aws_s3_bucket.cloudfront_logs
  ]

  tags = {
    Name = "blog-cdn-distribution"
  }
}

# CloudFront function for adding security headers
resource "aws_cloudfront_function" "add_security_headers" {
  name    = "blog-cdn-security-headers"
  runtime = "cloudfront-js-1.0"
  publish = true

  code = file("${path.module}/cloudfront-function.js")
}

# Origin request policy for custom headers
resource "aws_cloudfront_origin_request_policy" "blog_origin" {
  name = "blog-cdn-origin-policy"

  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["X-Origin-Verify", "User-Agent", "Accept", "Accept-Encoding"]
    }
  }

  query_strings_config {
    query_string_behavior = "none"
  }

  cookies_config {
    cookie_behavior = "none"
  }
}

# S3 bucket for CloudFront access logs
resource "aws_s3_bucket" "cloudfront_logs" {
  bucket = "blog-cdn-access-logs-${var.environment}"

  tags = {
    Name = "blog-cdn-logs"
  }
}

# S3 bucket versioning for logs
resource "aws_s3_bucket_versioning" "cloudfront_logs" {
  bucket = aws_s3_bucket.cloudfront_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket encryption for logs
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudfront_logs" {
  bucket = aws_s3_bucket.cloudfront_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 bucket lifecycle policy for logs
resource "aws_s3_bucket_lifecycle_configuration" "cloudfront_logs" {
  bucket = aws_s3_bucket.cloudfront_logs.id

  rule {
    id     = "archive-old-logs"
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

# Block public access to logs bucket
resource "aws_s3_bucket_public_access_block" "cloudfront_logs" {
  bucket = aws_s3_bucket.cloudfront_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket policy to allow CloudFront to write logs
resource "aws_s3_bucket_policy" "cloudfront_logs" {
  bucket = aws_s3_bucket.cloudfront_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontLogs"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::cloudfront:root"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudfront_logs.arn}/*"
      }
    ]
  })
}

resource "aws_wafv2_web_acl" "blog_cdn_waf" {
  name        = "blog-cdn-global-waf"
  description = "Advanced WAF for CloudFront with premium rule groups"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "BlogCDNWAFMetrics"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWSManagedRulesBotControlRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "WAFBotControl"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesATPRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesATPRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "WAFATP"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesACFPRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesACFPRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "WAFACFP"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 4

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "WAFCommon"
      sampled_requests_enabled   = true
    }
  }
}

# Append this dedicated ingestion stream to the bottom of main.tf
resource "aws_kinesis_stream" "gdpr_tracking_stream" {
  name             = "wanderlust-gdpr-tracking-events-${var.environment}"
  shard_count      = 3
  retention_period = 24

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = {
    Name        = "gdpr-tracking-stream"
    Environment = var.environment
  }
}


# Outputs consolidated in outputs.tf
