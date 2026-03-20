resource "aws_security_group" "alb" {
  name        = "alb-${var.environment}"
  description = "Allow HTTP(S) from internet"
  vpc_id      = aws_vpc.primary.id
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app" {
  name        = "app-${var.environment}"
  description = "Allow traffic from ALB and DR network"
  vpc_id      = aws_vpc.primary.id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    source_security_group_id = aws_security_group.alb.id
  }
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db" {
  name        = "db-${var.environment}"
  description = "Allow PostgreSQL from app SG"
  vpc_id      = aws_vpc.primary.id
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    source_security_group_id = aws_security_group.app.id
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
