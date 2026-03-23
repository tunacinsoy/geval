# Auto Scaling Group with Canary Deployment and Instance Refresh

resource "aws_autoscaling_group" "main" {
  name                      = "${var.project_name}-asg-${var.environment}"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = aws_subnet.private[*].id
  health_check_type         = "ELB"
  health_check_grace_period = 300

  # Reference latest launch template version
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  # Target group attachment (if ALB enabled)
  dynamic "target_group_arns" {
    for_each = var.enable_alb ? [aws_lb_target_group.main[0].arn] : []
    content {
      target_group_arns = [target_group_arns.value]
    }
  }

  instance_refresh {
    strategy = "Rolling"

    # Canary deployment: validate 10-20% first
    preferences {
      min_healthy_percentage   = 75
      instance_warmup_seconds  = 300
      checkpoint_percentage    = var.canary_deployment_percentage
      checkpoint_delay_seconds = 600   # Wait 10 minutes in canary phase
      skip_matching            = true  # Don't terminate instances with matching launch template
      automatic_rollback       = true  # Auto-rollback if health checks fail
      test_type                = "ELB" # Use ALB health checks for validation
    }

    trigger {
      key   = "launch_template"
      value = aws_launch_template.main.latest_version_number
    }
  }

  # Target tracking scaling policy - CPU based
  dynamic "tag" {
    for_each = merge(
      {
        Name        = "${var.project_name}-asg-${var.environment}"
        Environment = var.environment
        Propagate   = "true"
      },
      var.additional_tags
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = tag.value == "true" ? true : false
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_security_group.asg_instances,
    aws_launch_template.main
  ]
}

# ============================================================================
# Auto Scaling Policies
# ============================================================================

# Target Tracking Scaling Policy - Scale out at 70% CPU
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.project_name}-scale-out-${var.environment}"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.main.name

  # Alternative: Use target tracking
  # policy_type = "TargetTrackingScaling"
  # target_tracking_configuration {
  #   predefined_metric_specification {
  #     predefined_metric_type = "ASGAverageCPUUtilization"
  #   }
  #   target_value = 70.0
  # }
}

# Target Tracking Scaling Policy - Scale in at 30% CPU
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.project_name}-scale-in-${var.environment}"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.main.name
}

# ============================================================================
# Scheduled Actions for Cost Optimization
# ============================================================================

# Scale down during off-peak hours (10 PM - 6 AM UTC)
resource "aws_autoscaling_schedule" "scale_down" {
  count                  = var.cost_optimization_enabled ? 1 : 0
  scheduled_action_name  = "${var.project_name}-scale-down-${var.environment}"
  min_size               = 0
  max_size               = var.asg_max_size
  desired_capacity       = 0
  autoscaling_group_name = aws_autoscaling_group.main.name
  recurrence             = "0 22 * * *" # 10 PM UTC daily

  time_zone = "UTC"
}

# Scale up during business hours (6 AM UTC)
resource "aws_autoscaling_schedule" "scale_up" {
  count                  = var.cost_optimization_enabled ? 1 : 0
  scheduled_action_name  = "${var.project_name}-scale-up-${var.environment}"
  min_size               = var.asg_min_size
  max_size               = var.asg_max_size
  desired_capacity       = var.asg_desired_capacity
  autoscaling_group_name = aws_autoscaling_group.main.name
  recurrence             = "0 6 * * *" # 6 AM UTC daily

  time_zone = "UTC"
}

# ============================================================================
# Lifecycle Hooks for Graceful Termination (future phase)
# ============================================================================

# Note: Lifecycle hooks can be added in Phase 4 for enhanced drain behavior
# resource "aws_autoscaling_lifecycle_hook" "termination" {
#   name                   = "${var.project_name}-termination-hook-${var.environment}"
#   autoscaling_group_name = aws_autoscaling_group.main.name
#   lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
#   default_result         = "CONTINUE"
#   heartbeat_timeout      = 300
# }

# ============================================================================
# Outputs
# ============================================================================

output "asg_name" {
  value       = aws_autoscaling_group.main.name
  description = "Name of the Auto Scaling Group"
}

output "asg_arn" {
  value       = aws_autoscaling_group.main.arn
  description = "ARN of the Auto Scaling Group"
}

output "asg_min_size" {
  value       = aws_autoscaling_group.main.min_size
  description = "Minimum size of the Auto Scaling Group"
}

output "asg_max_size" {
  value       = aws_autoscaling_group.main.max_size
  description = "Maximum size of the Auto Scaling Group"
}

output "asg_desired_capacity" {
  value       = aws_autoscaling_group.main.desired_capacity
  description = "Desired capacity of the Auto Scaling Group"
}
