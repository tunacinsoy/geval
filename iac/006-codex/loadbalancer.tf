resource "aws_lb" "app" {
  name               = "app-alb-${var.environment}"
  load_balancer_type = "application"
  subnets            = values(aws_subnet.primary_public)[*].id
  security_groups    = [aws_security_group.alb.id]
  enable_deletion_protection = true
  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "app" {
  name     = "app-target-${var.environment}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.primary.id
  health_check {
    path                = "/health"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.app.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
