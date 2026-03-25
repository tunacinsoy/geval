locals {
  subnet_map = zipmap(var.private_subnet_cidrs, var.availability_zones)
}

resource "aws_vpc" "resolver_bridge" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.common_tags, {
    Name = "${local.project_prefix}-vpc-${var.environment}"
  })
}

resource "aws_subnet" "resolver_private" {
  for_each = local.subnet_map

  vpc_id                  = aws_vpc.resolver_bridge.id
  cidr_block              = each.key
  availability_zone       = each.value
  map_public_ip_on_launch = false
  tags = merge(var.common_tags, {
    Name = "${local.project_prefix}-private-${each.value}"
  })
}

resource "aws_route_table" "resolver_private" {
  vpc_id = aws_vpc.resolver_bridge.id
  tags = merge(var.common_tags, {
    Name = "${local.project_prefix}-rt-${var.environment}"
  })
}

resource "aws_route_table_association" "resolver_private" {
  for_each       = aws_subnet.resolver_private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.resolver_private.id
}
