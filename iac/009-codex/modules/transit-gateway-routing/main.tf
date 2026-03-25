resource "aws_ec2_transit_gateway_route" "resolver" {
  transit_gateway_route_table_id = var.transit_gateway_route_table_id
  destination_cidr_block         = var.destination_cidr_block
  blackhole                      = false
  transit_gateway_attachment_id  = var.transit_gateway_attachment_id
  tags                           = var.tags
}

resource "aws_ec2_transit_gateway_route_table_propagation" "attachment" {
  transit_gateway_attachment_id  = var.transit_gateway_attachment_id
  transit_gateway_route_table_id = var.transit_gateway_route_table_id
}
