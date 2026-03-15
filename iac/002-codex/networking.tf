locals {
  private_subnets = [
    "10.10.10.0/24",
    "10.10.20.0/24",
    "10.10.30.0/24",
  ]
  public_subnet = "10.10.1.0/24"
}

resource "aws_vpc" "hr_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "hr-vpc"
    Environment = var.environment
    Project     = "SecureHRDocs"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.hr_vpc.id
  tags = {
    Name        = "hr-igw"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.hr_vpc.id
  cidr_block        = local.public_subnet
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "hr-public"
  }
}

resource "aws_subnet" "private" {
  count             = length(local.private_subnets)
  vpc_id            = aws_vpc.hr_vpc.id
  cidr_block        = local.private_subnets[count.index]
  availability_zone = "${var.region}${element(["a", "b", "c"], count.index)}"
  tags = {
    Name = "hr-private-${count.index + 1}"
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "hr-nat"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.hr_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "hr-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.hr_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.hr_vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]
  tags = {
    Name = "hr-s3-endpoint"
  }
}

resource "aws_flow_log" "vpc" {
  log_destination      = aws_s3_bucket.audit_logs.arn
  log_destination_type = "s3"
  iam_role_arn         = aws_iam_role.flow_logs.arn
  resource_id          = aws_vpc.hr_vpc.id
  traffic_type         = "ALL"
  tags = {
    Name = "hr-flow-logs"
  }
  depends_on = [aws_iam_role.flow_logs]
}

resource "aws_vpc_endpoint_service" "hr_portal" {
  acceptance_required = false
  network_load_balancer_arns = [aws_lb.hr_alb.arn]
}
