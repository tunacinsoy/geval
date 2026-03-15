resource "aws_security_group" "alb" {
  name        = "playground-alb"
  description = "Allow HTTPS from team CIDRs"
  vpc_id      = aws_vpc.playground.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "playground-alb-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "compute" {
  name        = "playground-compute"
  description = "Only allow traffic from the ALB"
  vpc_id      = aws_vpc.playground.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "playground-compute-sg"
    Environment = var.environment
  }
}
