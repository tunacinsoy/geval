# VPC and subnets for Route 53 Resolver endpoints
# Assumes existing VPC with routing to Transit Gateway

data "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

# Inbound resolver endpoint subnet (us-east-1a)
resource "aws_subnet" "inbound_endpoint" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = var.inbound_endpoint_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "resolver-inbound-endpoint-subnet-${var.environment}"
  }
}

# Outbound resolver endpoint subnet (us-east-1b)
resource "aws_subnet" "outbound_endpoint" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = var.outbound_endpoint_subnet_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false

  tags = {
    Name = "resolver-outbound-endpoint-subnet-${var.environment}"
  }
}

# Route table for resolver subnets with Transit Gateway route
resource "aws_route_table" "resolver" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "resolver-route-table-${var.environment}"
  }
}

# Route to on-premises network via Transit Gateway
resource "aws_route" "tgw_route" {
  route_table_id                = aws_route_table.resolver.id
  destination_cidr_block        = var.on_premises_cidr
  transit_gateway_attachment_id = var.transit_gateway_attachment_id
}

# Associate inbound endpoint subnet with route table
resource "aws_route_table_association" "inbound" {
  subnet_id      = aws_subnet.inbound_endpoint.id
  route_table_id = aws_route_table.resolver.id
}

# Associate outbound endpoint subnet with route table
resource "aws_route_table_association" "outbound" {
  subnet_id      = aws_subnet.outbound_endpoint.id
  route_table_id = aws_route_table.resolver.id
}
