module "resolver_endpoints" {
  source  = "terraform-aws-modules/route53/aws//modules/resolver-endpoint"
  version = "6.4.0"

  create_inbound_endpoint  = true
  create_outbound_endpoint = true

  name = "hybrid-dns-resolver"

  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids

  inbound_security_group_ids = [module.resolver_sg.security_group_id]
  outbound_security_group_ids = [module.resolver_sg.security_group_id]

  tags = var.tags
}

resource "aws_route53_resolver_rule" "corp_internal_forward" {
  domain_name          = "${var.domain_name}."
  name                 = "corp-internal-forward-rule"
  rule_type            = "FORWARD"
  resolver_endpoint_id = module.resolver_endpoints.outbound_endpoint_id
  tags                 = var.tags

  dynamic "target_ip" {
    for_each = var.on_prem_dns_ips
    content {
      ip = target_ip.value
    }
  }
}

resource "aws_route53_resolver_rule_association" "corp_internal" {
  resolver_rule_id = aws_route53_resolver_rule.corp_internal_forward.id
  vpc_id           = var.vpc_id
}

resource "aws_cloudwatch_log_group" "resolver_query_logs" {
  name              = "/aws/route53/resolver-query-logs"
  retention_in_days = 30

  tags = var.tags
}

resource "aws_route53_resolver_query_log_config" "this" {
  name            = "resolver-query-logs"
  destination_arn = aws_cloudwatch_log_group.resolver_query_logs.arn
}

resource "aws_route53_resolver_query_log_config_association" "this" {
  resolver_query_log_config_id = aws_route53_resolver_query_log_config.this.id
  resource_id                  = var.vpc_id
}
