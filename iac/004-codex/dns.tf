resource "aws_route53_zone" "platform" {
  name = var.route53_zone_name
  vpc {
    vpc_id = module.vpc.vpc_id
  }
  comment = "Private zone for customer order data platform"
}

resource "aws_route53_record" "database_alias" {
  zone_id = aws_route53_zone.platform.zone_id
  name    = "db.${var.route53_zone_name}"
  type    = "CNAME"
  ttl     = 300
  records = [module.primary_db.db_endpoint]
}
