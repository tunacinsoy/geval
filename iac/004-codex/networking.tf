module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name                 = "customer-order-db-${var.environment}"
  cidr                 = var.vpc_cidr
  azs                  = var.azs
  public_subnets       = var.public_subnet_cidrs
  private_subnets      = var.private_subnet_cidrs
  enable_ipv6          = false
  enable_dns_support   = true
  enable_dns_hostnames = true

  enable_nat_gateway = true
  single_nat_gateway = false

  tags = merge(var.common_tags, {
    Name = "customer-order-vpc-${var.environment}"
  })
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = module.vpc.vpc_id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = module.vpc.public_route_table_ids
  tags = merge(var.common_tags, {
    Name = "s3-endpoint"
  })
}

locals {
  interface_endpoints = {
    secretsmanager = "com.amazonaws.${var.aws_region}.secretsmanager"
    ssm            = "com.amazonaws.${var.aws_region}.ssm"
    ssm_msgs       = "com.amazonaws.${var.aws_region}.ssmmessages"
  }
}

resource "aws_vpc_endpoint" "interface" {
  for_each       = local.interface_endpoints
  vpc_id         = module.vpc.vpc_id
  service_name   = each.value
  vpc_endpoint_type = "Interface"
  subnet_ids        = module.vpc.private_subnets
  security_group_ids = [aws_security_group.endpoint.id]
  private_dns_enabled = true
  tags = merge(var.common_tags, {
    Name = "${each.key}-endpoint"
  })
}

resource "aws_security_group" "endpoint" {
  name        = "endpoint-sg-${var.environment}"
  description = "Security group for VPC interface endpoints"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = [var.vpc_cidr]
    description     = "Allow VPC traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "endpoint-sg-${var.environment}"
  })
}

resource "aws_vpc_peering_connection" "website" {
  count = var.website_vpc_id != "" ? 1 : 0

  vpc_id        = module.vpc.vpc_id
  peer_vpc_id   = var.website_vpc_id
  peer_region   = var.aws_region
  auto_accept   = false
  tags = merge(var.common_tags, {
    Name = "website-peering-${var.environment}"
  })
}

resource "aws_route" "peer_to_website" {
  count = var.website_vpc_id != "" && var.website_vpc_cidr != "" ? length(module.vpc.private_route_table_ids) : 0

  route_table_id            = element(module.vpc.private_route_table_ids, count.index)
  destination_cidr_block    = var.website_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.website[0].id
}
