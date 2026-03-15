locals {
  expiration_date = timeadd(timestamp(), format("%sd", var.expiration_days))
}

resource "aws_launch_template" "playground" {
  name_prefix   = "playground-"
  image_id      = "ami-0c94855ba95c71c99" # Amazon Linux 2023 minimal (placeholder)
  instance_type = var.instance_type

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 40
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  network_interfaces {
    security_groups = [aws_security_group.compute.id]
    associate_public_ip_address = false
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.playground.name
  }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl enable --now httpd
    echo "Playground Instance" > /var/www/html/index.html
  EOT
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "playground-instance"
      Environment = var.environment
    }
  }
}

resource "aws_autoscaling_group" "playground" {
  name                    = "playground-asg"
  max_size                = var.max_size
  min_size                = 1
  desired_capacity        = 1
  vpc_zone_identifier     = [for s in aws_subnet.private : s.id]
  launch_template {
    id      = aws_launch_template.playground.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.playground.arn]

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
  tag {
    key                 = "TeardownDate"
    value               = local.expiration_date
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "playground-scale-up"
  autoscaling_group_name = aws_autoscaling_group.playground.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50
    scale_out_cooldown = 60
    scale_in_cooldown  = 60
  }
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "playground-scale-down"
  autoscaling_group_name = aws_autoscaling_group.playground.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value        = 30
    disable_scale_in    = false
    scale_out_cooldown  = 120
    scale_in_cooldown   = 120
  }
}