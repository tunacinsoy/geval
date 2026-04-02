# CloudWatch Monitoring and Alarms for RDS Database

# SNS Topic for alarm notifications
resource "aws_sns_topic" "database_alerts" {
  name_prefix = "orders-db-alerts-${var.environment}-"

  tags = merge(
    var.tags,
    {
      Name = "database-alerts-${var.environment}"
    }
  )
}

# SNS Topic Policy to allow CloudWatch to publish
resource "aws_sns_topic_policy" "database_alerts" {
  arn = aws_sns_topic.database_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.database_alerts.arn
      }
    ]
  })
}

# CloudWatch Alarm: Database Availability
resource "aws_cloudwatch_metric_alarm" "rds_availability" {
  alarm_name          = "orders-db-availability-${var.environment}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DBInstanceAvailability"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 99.0
  alarm_description   = "Alert when RDS database availability drops below 99%"
  alarm_actions       = [aws_sns_topic.database_alerts.arn]
  treat_missing_data  = "breaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.orders.id
  }

  tags = var.tags
}

# CloudWatch Alarm: CPU Utilization (high)
resource "aws_cloudwatch_metric_alarm" "rds_cpu_utilization" {
  alarm_name          = "orders-db-cpu-high-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80.0
  alarm_description   = "Alert when RDS CPU utilization exceeds 80%"
  alarm_actions       = [aws_sns_topic.database_alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.orders.id
  }

  tags = var.tags
}

# CloudWatch Alarm: Free Storage Space (low)
resource "aws_cloudwatch_metric_alarm" "rds_storage_low" {
  alarm_name          = "orders-db-storage-low-${var.environment}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 5368709120 # 5 GB in bytes (20% of 20GB)
  alarm_description   = "Alert when RDS free storage drops below 5 GB"
  alarm_actions       = [aws_sns_topic.database_alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.orders.id
  }

  tags = var.tags
}

# CloudWatch Alarm: Database Connections (high)
resource "aws_cloudwatch_metric_alarm" "rds_connections_high" {
  alarm_name          = "orders-db-connections-high-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80.0 # 80% of 100 concurrent connections
  alarm_description   = "Alert when database connections exceed 80 (80% of 100 limit)"
  alarm_actions       = [aws_sns_topic.database_alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.orders.id
  }

  tags = var.tags
}

# CloudWatch Alarm: Read Latency (high)
resource "aws_cloudwatch_metric_alarm" "rds_read_latency" {
  alarm_name          = "orders-db-read-latency-high-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ReadLatency"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 100.0 # milliseconds
  alarm_description   = "Alert when RDS read latency exceeds 100ms"
  alarm_actions       = [aws_sns_topic.database_alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.orders.id
  }

  tags = var.tags
}

# CloudWatch Alarm: Write Latency (high)
resource "aws_cloudwatch_metric_alarm" "rds_write_latency" {
  alarm_name          = "orders-db-write-latency-high-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "WriteLatency"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 100.0 # milliseconds
  alarm_description   = "Alert when RDS write latency exceeds 100ms"
  alarm_actions       = [aws_sns_topic.database_alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.orders.id
  }

  tags = var.tags
}

# CloudWatch Log Group for RDS PostgreSQL Logs
resource "aws_cloudwatch_log_group" "rds_postgresql" {
  name              = "/aws/rds/instance/${aws_db_instance.orders.id}/postgresql"
  retention_in_days = var.environment == "prod" ? 90 : 30

  tags = merge(
    var.tags,
    {
      Name = "rds-postgresql-logs-${var.environment}"
    }
  )
}

# CloudWatch Dashboard for monitoring RDS metrics
resource "aws_cloudwatch_dashboard" "orders_database" {
  dashboard_name = "orders-database-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", { stat = "Average" }],
            [".", "DatabaseConnections", { stat = "Average" }],
            [".", "FreeStorageSpace", { stat = "Average" }]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "RDS Instance Metrics"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/RDS", "ReadLatency", { stat = "Average" }],
            [".", "WriteLatency", { stat = "Average" }],
            [".", "ReadThroughput", { stat = "Average" }],
            [".", "WriteThroughput", { stat = "Average" }]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "RDS Performance Metrics"
        }
      }
    ]
  })
}

# Note: Composite alarms could be created here to combine multiple alarms
# This requires additional dependencies and is optional for basic monitoring

# EventBridge Rule for RDS events
resource "aws_cloudwatch_event_rule" "rds_events" {
  name_prefix    = "rds-events-${var.environment}-"
  description    = "Capture RDS database events"
  event_bus_name = "default"
  state          = "ENABLED"
  event_pattern = jsonencode({
    source = ["aws.rds"]
    detail-type = [
      "RDS DB Instance Event",
      "RDS DB Cluster Event",
      "RDS DB Parameter Group Event",
      "RDS DB Security Group Event"
    ]
  })

  tags = var.tags
}

# EventBridge Target to send RDS events to SNS
resource "aws_cloudwatch_event_target" "rds_events_to_sns" {
  rule      = aws_cloudwatch_event_rule.rds_events.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.database_alerts.arn

  retry_policy {
    maximum_event_age_in_seconds = 3600
    maximum_retry_attempts       = 2
  }
}
