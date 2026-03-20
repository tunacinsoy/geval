data "aws_availability_zones" "primary" {
  state = "available"
}

data "aws_availability_zones" "dr" {
  state = "available"
}

resource "aws_vpc" "primary" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "primary-${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_vpc" "dr" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "dr-${var.environment}-vpc"
    Environment = var.environment
  }
}

locals {
  primary_azs = slice(data.aws_availability_zones.primary.names, 0, 2)
  dr_azs      = slice(data.aws_availability_zones.dr.names, 0, 2)
}

data "aws_caller_identity" "current" {}
