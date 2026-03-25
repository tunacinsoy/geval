module "transit_gateway_routing" {
  source                         = "./modules/transit-gateway-routing"
  transit_gateway_route_table_id = var.transit_gateway_route_table_id
  transit_gateway_attachment_id  = var.transit_gateway_id
  destination_cidr_block         = var.on_prem_cidr
  tags = merge(var.common_tags, {
    Name = "${local.project_prefix}-tgw-route"
  })
}
