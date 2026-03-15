resource "aws_acm_certificate" "site" {
  domain_name               = var.primary_domain
  validation_method         = "DNS"
  subject_alternative_names = [var.www_domain]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = { for dvo in aws_acm_certificate.site.domain_validation_options : dvo.domain_name => dvo }

  zone_id = var.route53_zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "site" {
  certificate_arn         = aws_acm_certificate.site.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

resource "aws_cloudfront_origin_access_control" "assets" {
  name    = "flower-shop-oac-${var.environment}"
  description = "Restricts S3 bucket access to the CloudFront distribution"
  signing_behavior = "always"
  signing_protocol = "sigv4"
  origin_type      = "s3"
}

resource "aws_cloudfront_response_headers_policy" "security" {
  name = "flower-shop-security-headers-${var.environment}"

  security_headers_config {
    hsts {
      access_control_max_age_sec = 63072000
      include_subdomains         = true
      preload                    = true
    }

    content_security_policy {
      content_security_policy = "default-src https: data:; img-src https: data: blob:; font-src 'self' https: data:; object-src 'none'"
      override             = true
    }

    referrer_policy {
      override = true
      policy   = "strict-origin-when-cross-origin"
    }

    xss_protection {
      protection = true
      mode_block = true
    }

    frame_options {
      frame_option = "DENY"
    }
  }
}

resource "aws_cloudfront_distribution" "site" {
  enabled             = true
  default_root_object = "index.html"
  aliases             = [var.primary_domain, var.www_domain]

  origin {
    domain_name = aws_s3_bucket.assets.bucket_regional_domain_name
    origin_id   = "assets-origin"

    origin_access_control_id = aws_cloudfront_origin_access_control.assets.id
  }

  default_cache_behavior {
    target_origin_id       = "assets-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    response_headers_policy_id = aws_cloudfront_response_headers_policy.security.id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = var.cache_ttl_seconds
    max_ttl     = var.cache_ttl_seconds
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.site.arn
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.3_2021"
  }

  logging_config {
    bucket = aws_s3_bucket.logs.bucket_domain_name
    include_cookies = false
    prefix = "cloudfront/"
  }

  wait_for_deployment = true
}
