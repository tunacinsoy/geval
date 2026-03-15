resource "aws_cloudwatch_dashboard" "hr" {
  dashboard_name = "HR-Portal"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        x    = 0
        y    = 0
        width = 24
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.hr_alb.name],
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_lb.hr_alb.name]
          ]
          view = "timeSeries"
          region = var.region
          stacked = false
          title = "ALB Traffic & Response"
        }
      }
    ]
  })
}

resource "aws_sns_topic" "alerts" {
  name = "hr-portal-alerts"
}

resource "aws_cloudwatch_metric_alarm" "latency" {
  alarm_name          = "hr-portal-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 2
  dimensions = {
    LoadBalancer = aws_lb.hr_alb.name
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "server_errors" {
  alarm_name          = "hr-portal-server-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  dimensions = {
    LoadBalancer = aws_lb.hr_alb.name
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
}
