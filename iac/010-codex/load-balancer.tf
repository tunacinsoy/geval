resource "aws_lb" "app" {
  name     = "hardened-app-lb"
  internal = false
  load_balancer_type = "application"
  subnets  = values(aws_subnet.public)[*].id
  security_groups = [aws_security_group.alb.id]
  enable_deletion_protection = true
}

resource "aws_lb_target_group" "app" {
  name     = "hardened-app-tg"
  port     = 443
  protocol = "HTTPS"
  target_type = "instance"
  vpc_id   = aws_vpc.main.id
  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTPS"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2021-06"
  certificate_arn   = "arn:aws:acm:us-east-1:123456789012:certificate/example"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
