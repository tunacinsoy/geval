resource "aws_lb" "primary" {
  provider           = aws
  name               = "primary-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.primary_public.id]
}

resource "aws_lb" "dr" {
  provider           = aws.dr
  name               = "dr-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dr_alb.id]
  subnets            = [aws_subnet.dr_public.id]
}

resource "aws_lb_target_group" "primary" {
  provider = aws
  name     = "primary-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.primary.id
}

resource "aws_lb_target_group" "dr" {
  provider = aws.dr
  name     = "dr-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.dr.id
}

resource "aws_lb_listener" "primary" {
  provider          = aws
  load_balancer_arn = aws_lb.primary.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:iam::123456789012:server-certificate/my-server-cert" # Placeholder

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.primary.arn
  }
}

resource "aws_lb_listener" "dr" {
  provider          = aws.dr
  load_balancer_arn = aws_lb.dr.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:iam::123456789012:server-certificate/my-server-cert" # Placeholder

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dr.arn
  }
}
