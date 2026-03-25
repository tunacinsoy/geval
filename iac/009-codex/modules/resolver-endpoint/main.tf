resource "aws_route53_resolver_endpoint" "this" {
  name               = "${var.name_prefix}-${lower(var.direction)}"
  direction          = var.direction
  security_group_ids = var.security_group_ids

  ip_address {
    subnet_id = var.subnet_ids[0]
  }

  dynamic "ip_address" {
    for_each = length(var.subnet_ids) > 1 ? slice(var.subnet_ids, 1, length(var.subnet_ids)) : []
    content {
      subnet_id = ip_address.value
    }
  }

  tags = var.tags
}
