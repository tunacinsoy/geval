resource "aws_security_group" "alb" {
  provider    = aws
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.primary.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app" {
  provider    = aws
  name        = "app-sg"
  description = "Security group for application"
  vpc_id      = aws_vpc.primary.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
}

resource "aws_security_group" "db" {
  provider    = aws
  name        = "db-sg"
  description = "Security group for database"
  vpc_id      = aws_vpc.primary.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }
}

resource "aws_security_group" "dr_alb" {
  provider    = aws.dr
  name        = "dr-alb-sg"
  description = "Security group for DR ALB"
  vpc_id      = aws_vpc.dr.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "dr_app" {
  provider    = aws.dr
  name        = "dr-app-sg"
  description = "Security group for DR application"
  vpc_id      = aws_vpc.dr.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.dr_alb.id]
  }
}

resource "aws_security_group" "dr_db" {
  provider    = aws.dr
  name        = "dr-db-sg"
  description = "Security group for DR database"
  vpc_id      = aws_vpc.dr.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.dr_app.id]
  }
}
