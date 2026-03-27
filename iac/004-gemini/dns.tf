resource "aws_route53_zone" "private" {
  name = "db.internal"

  vpc {
    vpc_id = aws_vpc.main.id
  }
}

resource "aws_route53_record" "db_record" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.main.address]
}
