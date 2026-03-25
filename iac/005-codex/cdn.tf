resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for the primary image bucket"
}

resource "aws_cloudfront_cache_policy" "image_cache" {
  name        = "global-image-cache-policy"
  default_ttl = var.cache_ttl_seconds
  max_ttl     = var.cache_ttl_seconds * 2
  min_ttl     = 60
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "whitelist"
      headers         = ["CloudFront-Viewer-Country"]
    }
    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "security_headers" {
  name            = "global-image-origin-request-policy"
  header_behavior = "whitelist"
  headers = [
    "CloudFront-Viewer-Device-Type",
    "CloudFront-Viewer-Device-Width",
    "CloudFront-Viewer-Country"
  ]
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Global image delivery distribution"
  price_class         = var.edge_price_class
  aliases             = [var.blog_domain]
  default_root_object = "index.html"

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.blog.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  origin {
    domain_name = aws_s3_bucket.primary.bucket_regional_domain_name
    origin_id   = "primary-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_s3_bucket.failover.bucket_regional_domain_name
    origin_id   = "failover-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id         = "primary-origin"
    viewer_protocol_policy   = "redirect-to-https"
    allowed_methods          = ["GET", "HEAD", "OPTIONS"]
    cached_methods           = ["GET", "HEAD"]
    cache_policy_id          = aws_cloudfront_cache_policy.image_cache.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.security_headers.id
    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.image_optimizer.arn
    }
    default_ttl      = var.cache_ttl_seconds
    min_ttl          = 60
    max_ttl          = var.cache_ttl_seconds * 2
    smooth_streaming = false
    compress         = true
  }

  ordered_cache_behavior {
    path_pattern             = "/origin-invalidation/*"
    target_origin_id         = "failover-origin"
    viewer_protocol_policy   = "https-only"
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    cache_policy_id          = aws_cloudfront_cache_policy.image_cache.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.security_headers.id
  }

  logging_config {
    bucket          = aws_s3_bucket.logging.bucket_domain_name
    include_cookies = false
    prefix          = "cloudfront/"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "AU", "SG"]
    }
  }

}
