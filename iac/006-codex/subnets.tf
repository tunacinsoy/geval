locals {
  primary_public_cidrs = [for idx, az in enumerate(local.primary_azs) : cidrsubnet(var.vpc_cidr, 8, idx)]
  primary_private_cidrs = [for idx, az in enumerate(local.primary_azs) : cidrsubnet(var.vpc_cidr, 8, idx + 10)]
  dr_public_cidrs = [for idx, az in enumerate(local.dr_azs) : cidrsubnet(var.vpc_cidr, 8, idx + 20)]
  dr_private_cidrs = [for idx, az in enumerate(local.dr_azs) : cidrsubnet(var.vpc_cidr, 8, idx + 30)]
}

resource "aws_subnet" "primary_public" {
  for_each = toset(local.primary_azs)
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = element(local.primary_public_cidrs, index(local.primary_azs, each.key))
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = {
    Name        = "primary-public-${each.key}-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "primary_private" {
  for_each = toset(local.primary_azs)
  vpc_id            = aws_vpc.primary.id
  cidr_block        = element(local.primary_private_cidrs, index(local.primary_azs, each.key))
  availability_zone = each.key
  tags = {
    Name        = "primary-private-${each.key}-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "dr_public" {
  for_each = toset(local.dr_azs)
  vpc_id                  = aws_vpc.dr.id
  cidr_block              = element(local.dr_public_cidrs, index(local.dr_azs, each.key))
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = {
    Name        = "dr-public-${each.key}-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "dr_private" {
  for_each = toset(local.dr_azs)
  vpc_id            = aws_vpc.dr.id
  cidr_block        = element(local.dr_private_cidrs, index(local.dr_azs, each.key))
  availability_zone = each.key
  tags = {
    Name        = "dr-private-${each.key}-${var.environment}"
    Environment = var.environment
  }
}
