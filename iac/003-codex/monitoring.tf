resource "aws_cloudwatch_log_group" "playground" {
  name              = "/playground/app"
  retention_in_days = 7
  tags = {
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_metric_filter" "http_errors" {
  name           = "playground-4xx-errors"
  log_group_name = aws_cloudwatch_log_group.playground.name

  pattern = "[host, request, status_code=4*, ...]"

  metric_transformation {
    name      = "Playground4xxCount"
    namespace = "Playground"
    value     = "1"
  }
}

resource "aws_sns_topic" "alerts" {
  name = "playground-alerts"
}

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy" {
  alarm_name                = "playground-alb-unhealthy"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = 2
  metric_name               = "HealthyHostCount"
  namespace                 = "AWS/ApplicationELB"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 1
  dimensions = {
    LoadBalancer = aws_lb.playground.arn_suffix
  }
  alarm_description = "Alert when the load balancer has no healthy targets"
  alarm_actions     = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "instance_missing" {
  alarm_name          = "playground-instance-missing"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 3
  metric_name         = "GroupInServiceInstances"
  namespace           = "AWS/AutoScaling"
  period              = 60
  threshold           = 1
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.playground.name
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
}
