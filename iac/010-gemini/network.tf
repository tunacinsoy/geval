data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnet" "build_subnet" {
  id = var.private_subnet_ids[0]
}

resource "aws_security_group" "image_builder_sg" {
  name        = "image-builder-build-sg"
  description = "Security group for Image Builder instances"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app-cluster-sg"
  description = "Security group for application instances"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}