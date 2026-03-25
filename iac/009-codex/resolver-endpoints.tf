module "inbound_endpoint" {
  source             = "./modules/resolver-endpoint"
  name_prefix        = local.project_prefix
  direction          = "INBOUND"
  subnet_ids         = values(aws_subnet.resolver_private)[*].id
  security_group_ids = [aws_security_group.resolver_endpoint.id]
  tags               = var.common_tags
}

module "outbound_endpoint" {
  source             = "./modules/resolver-endpoint"
  name_prefix        = local.project_prefix
  direction          = "OUTBOUND"
  subnet_ids         = values(aws_subnet.resolver_private)[*].id
  security_group_ids = [aws_security_group.resolver_endpoint.id]
  tags               = var.common_tags
}
