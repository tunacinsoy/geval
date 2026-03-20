resource "aws_internet_gateway" "primary" {
  vpc_id = aws_vpc.primary.id
  tags = {
    Name = "primary-igw-${var.environment}"
  }
}

resource "aws_internet_gateway" "dr" {
  vpc_id = aws_vpc.dr.id
  tags = {
    Name = "dr-igw-${var.environment}"
  }
}

resource "aws_route_table" "primary_public" {
  vpc_id = aws_vpc.primary.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary.id
  }
  tags = {
    Name = "primary-public-rt-${var.environment}"
  }
}

resource "aws_route_table" "dr_public" {
  vpc_id = aws_vpc.dr.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dr.id
  }
  tags = {
    Name = "dr-public-rt-${var.environment}"
  }
}

resource "aws_eip" "primary_nat" {
  vpc = true
  tags = {
    Name = "primary-nat-eip-${var.environment}"
  }
}

resource "aws_nat_gateway" "primary" {
  allocation_id = aws_eip.primary_nat.id
  subnet_id     = values(aws_subnet.primary_public)[0].id
  depends_on    = [aws_internet_gateway.primary]
  tags = {
    Name = "primary-nat-${var.environment}"
  }
}

resource "aws_route_table" "primary_private" {
  vpc_id = aws_vpc.primary.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.primary.id
  }
  tags = {
    Name = "primary-private-rt-${var.environment}"
  }
}

resource "aws_eip" "dr_nat" {
  provider = aws.dr
  vpc      = true
  tags = {
    Name = "dr-nat-eip-${var.environment}"
  }
}

resource "aws_nat_gateway" "dr" {
  provider      = aws.dr
  allocation_id = aws_eip.dr_nat.id
  subnet_id     = values(aws_subnet.dr_public)[0].id
  depends_on    = [aws_internet_gateway.dr]
  tags = {
    Name = "dr-nat-${var.environment}"
  }
}

resource "aws_route_table" "dr_private" {
  provider = aws.dr
  vpc_id   = aws_vpc.dr.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dr.id
  }
  tags = {
    Name = "dr-private-rt-${var.environment}"
  }
}

data "aws_route_table" "primary_public_rt" {
  id = aws_route_table.primary_public.id
}

resource "aws_route_table_association" "primary_public" {
  for_each = aws_subnet.primary_public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.primary_public.id
}

resource "aws_route_table_association" "primary_private" {
  for_each = aws_subnet.primary_private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.primary_private.id
}

resource "aws_route_table_association" "dr_public" {
  for_each = aws_subnet.dr_public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.dr_public.id
}

resource "aws_route_table_association" "dr_private" {
  for_each = aws_subnet.dr_private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.dr_private.id
}
