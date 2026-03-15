resource "aws_lb" "playground" {
  name               = "playground-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for s in aws_subnet.public : s.id]
  security_groups    = [aws_security_group.alb.id]

  tags = {
    Environment = var.environment
    Name        = "playground-alb"
  }
}

resource "aws_lb_target_group" "playground" {
  name     = "playground-targets"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.playground.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.playground.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy     = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.playground.arn
  }
}
