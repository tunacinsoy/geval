resource "aws_lb" "hr_alb" {
  name               = "hr-docs-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.private[*].id
  enable_deletion_protection = true
  tags = {
    Environment = var.environment
    Project     = "SecureHRDocs"
  }
}

resource "aws_lb_target_group" "hr_targets" {
  name     = "hr-targets"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.hr_vpc.id
  health_check {
    path                = "/health"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.hr_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.acm_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hr_targets.arn
  }
}
