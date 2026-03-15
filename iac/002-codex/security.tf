resource "aws_security_group" "alb" {
  name        = "hr-alb"
  description = "Allow HTTPS traffic from internal networks"
  vpc_id      = aws_vpc.hr_vpc.id
  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "hr-alb-sg"
  }
}

resource "aws_security_group" "tasks" {
  name        = "hr-tasks"
  description = "Allow egress to S3 and logging"
  vpc_id      = aws_vpc.hr_vpc.id
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "hr-tasks-sg"
  }
}

resource "aws_security_group" "logging" {
  name        = "hr-logging"
  description = "Allow log streamers to send data"
  vpc_id      = aws_vpc.hr_vpc.id
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_guardduty_detector" "main" {
  enable = true
}

resource "aws_securityhub_account" "main" {}

resource "aws_config_delivery_channel" "default" {
  name           = "hr-config-channel"
  s3_bucket_name = aws_s3_bucket.audit_logs.id
  depends_on     = [aws_config_configuration_recorder.main]
}

resource "aws_config_configuration_recorder" "main" {
  name     = "hr-config-recorder"
  role_arn = aws_iam_role.config.arn
}
