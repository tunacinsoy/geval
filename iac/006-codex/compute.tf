data "aws_ami" "linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "app-lt-${var.environment}-"
  image_id      = data.aws_ami.linux.id
  instance_type = var.application_instance_type
  key_name      = var.key_pair_name
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Environment = var.environment
      Purpose     = "application"
    }
  }
}

resource "aws_autoscaling_group" "app" {
  name                      = "app-asg-${var.environment}"
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
  min_size                  = var.application_desired_capacity
  max_size                  = var.application_desired_capacity * 2
  desired_capacity          = var.application_desired_capacity
  vpc_zone_identifier       = values(aws_subnet.primary_private)[*].id
  target_group_arns         = [aws_lb_target_group.app.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 120
  tags = [
    {
      key                 = "Environment"
      value               = var.environment
      propagate_at_launch = true
    },
    {
      key                 = "Role"
      value               = "application"
      propagate_at_launch = true
    }
  ]
}

resource "aws_autoscaling_policy" "cpu_scale" {
  name = "cpu-scale-${var.environment}"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 65
  }
}
