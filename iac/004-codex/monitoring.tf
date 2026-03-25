resource "aws_cloudwatch_dashboard" "platform" {
  dashboard_name = "customer-order-platform-${var.environment}"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        x = 0
        y = 0
        width = 12
        height = 6
        properties = {
          view = "timeSeries"
          title = "Database write latency"
          metrics = [
            [
              "AWS/RDS",
              "WriteLatency",
              "DBInstanceIdentifier",
              module.primary_db.db_instance_identifier
            ]
          ]
          period = 300
          stat = "Average"
          region = var.aws_region
        }
      },
      {
        type = "metric"
        x = 0
        y = 6
        width = 12
        height = 6
        properties = {
          view = "timeSeries"
          title = "Lambda invocation errors"
          metrics = [
            [
              "AWS/Lambda",
              "Errors",
              "FunctionName",
              aws_lambda_function.validation_function.function_name
            ]
          ]
          period = 300
          stat = "Sum"
          region = var.aws_region
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "db_cpu" {
  alarm_name          = "rds-cpu-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  dimensions = {
    DBInstanceIdentifier = module.primary_db.db_instance_identifier
  }
  alarm_description = "CPU spikes on the primary database"
  actions_enabled    = true
  alarm_actions      = [aws_sns_topic.alerts.arn]
}
