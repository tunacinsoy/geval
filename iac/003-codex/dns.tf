resource "aws_route53_zone" "private" {
  name = var.allowed_private_zone
  vpc {
    vpc_id = aws_vpc.playground.id
  }
  tags = {
    Environment = var.environment
  }
}

resource "aws_route53_record" "playground" {
  zone_id = aws_route53_zone.private.id
  name    = var.team_dns_prefix
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.playground.dns_name]
}
