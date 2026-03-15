resource "aws_vpc" "playground" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name        = "playground-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "playground" {
  vpc_id = aws_vpc.playground.id
  tags = {
    Name        = "playground-igw"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  for_each = toset(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.playground.id
  cidr_block              = each.value
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "playground-public-${each.key}"
    Environment = var.environment
  }
}

resource "aws_subnet" "private" {
  for_each = toset(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.playground.id
  cidr_block        = each.value
  availability_zone = "${var.region}a"
  tags = {
    Name        = "playground-private-${each.key}"
    Environment = var.environment
  }
}

resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name        = "playground-nat-eip"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "playground" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(values(aws_subnet.public), 0).id
  tags = {
    Name        = "playground-nat"
    Environment = var.environment
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.playground.id
  tags = {
    Name        = "playground-private-rt"
    Environment = var.environment
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.playground.id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.playground.id
  tags = {
    Name        = "playground-public-rt"
    Environment = var.environment
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.playground.id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
