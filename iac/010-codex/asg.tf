resource "aws_autoscaling_group" "app" {
  name                      = "hardened-app-asg"
  launch_template {
    id      = aws_launch_template.hardened.id
    version = aws_launch_template.hardened.latest_version
  }
  min_size                  = var.asg_min_size
  desired_capacity          = var.asg_desired_capacity
  max_size                  = var.asg_max_size
  target_group_arns         = [aws_lb_target_group.app.arn]
  vpc_zone_identifier       = values(aws_subnet.private)[*].id
  health_check_type         = "ELB"
  health_check_grace_period = 120
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "hardened-asg"
    propagate_at_launch = true
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      instance_warmup = 180
      min_healthy_percentage = 90
    }
    triggers = ["launch_configuration", "launch_template"]
  }
}
