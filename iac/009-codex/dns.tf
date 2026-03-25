resource "aws_route53_resolver_rule" "corp_internal" {
  name                 = "corp-internal-forward"
  domain_name          = "corp.internal"
  rule_type            = "FORWARD"
  resolver_endpoint_id = module.outbound_endpoint.endpoint_id
  target_ip {
    ip = "192.168.10.5"
  }
  target_ip {
    ip = "192.168.10.6"
  }
  tags = var.common_tags
}

resource "aws_route53_resolver_rule_association" "corp_vpc" {
  resolver_rule_id = aws_route53_resolver_rule.corp_internal.id
  vpc_id           = aws_vpc.resolver_bridge.id
}
