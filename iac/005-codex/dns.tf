resource "aws_route53_zone" "blog" {
  name    = var.blog_domain
  comment = var.zone_comment
}

resource "aws_route53_health_check" "cdn" {
  type              = "HTTPS"
  resource_path     = "/"
  fqdn              = aws_cloudfront_distribution.cdn.domain_name
  measure_latency   = true
  failure_threshold = 2
}

resource "aws_route53_record" "cdn_alias" {
  zone_id = aws_route53_zone.blog.zone_id
  name    = var.blog_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = true
  }

  health_check_id = aws_route53_health_check.cdn.id
}
