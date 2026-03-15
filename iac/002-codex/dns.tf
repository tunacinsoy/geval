resource "aws_route53_zone" "hr_private" {
  name = var.private_zone_name
  vpc {
    vpc_id = aws_vpc.hr_vpc.id
  }
  tags = {
    Environment = var.environment
  }
}

resource "aws_route53_record" "portal" {
  zone_id = aws_route53_zone.hr_private.zone_id
  name    = "portal.${var.private_zone_name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.hr_alb.dns_name]
}
