resource "aws_vpc" "primary" {
  provider   = aws
  cidr_block = "10.10.0.0/16"

  tags = {
    Name        = "primary-vpc"
    Environment = "production"
    Project     = "multi-region-dr"
  }
}

resource "aws_vpc" "dr" {
  provider   = aws.dr
  cidr_block = "10.10.0.0/16"

  tags = {
    Name        = "dr-vpc"
    Environment = "production"
    Project     = "multi-region-dr"
  }
}

resource "aws_subnet" "primary_public" {
  provider          = aws
  vpc_id            = aws_vpc.primary.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "${var.primary_region}a"
}

resource "aws_subnet" "primary_private" {
  provider          = aws
  vpc_id            = aws_vpc.primary.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "${var.primary_region}a"
}

resource "aws_subnet" "dr_public" {
  provider          = aws.dr
  vpc_id            = aws_vpc.dr.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "${var.dr_region}a"
}

resource "aws_subnet" "dr_private" {
  provider          = aws.dr
  vpc_id            = aws_vpc.dr.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "${var.dr_region}a"
}

resource "aws_vpc_peering_connection" "peer" {
  provider      = aws
  peer_vpc_id   = aws_vpc.dr.id
  vpc_id        = aws_vpc.primary.id
  peer_region   = var.dr_region
  auto_accept   = true
}
