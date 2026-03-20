resource "aws_vpc_peering_connection" "primary_dr" {
  vpc_id        = aws_vpc.primary.id
  peer_vpc_id   = aws_vpc.dr.id
  peer_region   = var.dr_region
  auto_accept   = false
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  requester {
    allow_remote_vpc_dns_resolution = true
  }
  tags = {
    Name        = "primary-dr-peering-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_vpc_peering_connection_accepter" "dr" {
  provider                  = aws.dr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_dr.id
  auto_accept               = true
  tags = {
    Name = "dr-peering-accept-${var.environment}"
  }
}

resource "aws_route" "primary_to_dr" {
  route_table_id         = aws_route_table.primary_private.id
  destination_cidr_block = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_dr.id
}

resource "aws_route" "dr_to_primary" {
  provider                = aws.dr
  route_table_id          = aws_route_table.dr_private.id
  destination_cidr_block  = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_dr.id
}
