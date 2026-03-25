resource "aws_acm_certificate" "blog" {
  provider          = aws.us_east_1
  domain_name       = var.blog_domain
  validation_method = "DNS"

  tags = {
    Purpose = "CloudFront TLS"
  }
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.blog.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.blog.domain_validation_options[0].resource_record_type
  zone_id = aws_route53_zone.blog.zone_id
  records = [aws_acm_certificate.blog.domain_validation_options[0].resource_record_value]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "blog" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.blog.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
