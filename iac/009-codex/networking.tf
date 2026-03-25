resource "aws_route" "corp_internal" {
  route_table_id         = aws_route_table.resolver_private.id
  destination_cidr_block = var.on_prem_cidr
  transit_gateway_id     = var.transit_gateway_id
}

resource "aws_network_acl" "resolver" {
  vpc_id = aws_vpc.resolver_bridge.id
  tags   = merge(var.common_tags, { Name = "${local.project_prefix}-acl-${var.environment}" })
}

resource "aws_network_acl_rule" "resolver_ingress_tcp" {
  network_acl_id = aws_network_acl.resolver.id
  rule_number    = 100
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = var.on_prem_cidr
  from_port      = 53
  to_port        = 53
  egress         = false
}

resource "aws_network_acl_rule" "resolver_ingress_udp" {
  network_acl_id = aws_network_acl.resolver.id
  rule_number    = 110
  protocol       = "17"
  rule_action    = "allow"
  cidr_block     = var.on_prem_cidr
  from_port      = 53
  to_port        = 53
  egress         = false
}
