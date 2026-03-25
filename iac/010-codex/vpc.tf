data "aws_availability_zones" "available" {}

locals {
  azs = take(data.aws_availability_zones.available.names, length(var.public_subnet_cidrs) + length(var.private_subnet_cidrs))
  public_subnets = zipmap(var.public_subnet_cidrs, slice(local.azs, 0, length(var.public_subnet_cidrs)))
  private_subnets = zipmap(var.private_subnet_cidrs, slice(local.azs, length(var.public_subnet_cidrs), length(var.public_subnet_cidrs) + length(var.private_subnet_cidrs)))
  primary_public_subnet = keys(local.public_subnets)[0]
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "hardened-image-pipeline"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "hardened-igw"
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.key
  availability_zone = each.value
  map_public_ip_on_launch = true
  tags = {
    Name = "public-${replace(each.key, ".", "-")}-${each.value}"
  }
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.key
  availability_zone = each.value
  tags = {
    Name = "private-${replace(each.key, ".", "-")}-${each.value}"
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[local.primary_public_subnet].id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "pipeline-nat"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private-rt"
  }
}

resource "aws_route" "nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
