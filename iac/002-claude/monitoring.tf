# CloudWatch Dashboards and Alarms for Operational Visibility

# SNS topic for alerts
resource "aws_sns_topic" "infrastructure_alerts" {
  name = "hr-documents-alerts-${var.environment}"

  tags = merge(
    var.tags,
    {
      Name = "hr-documents-alerts-${var.environment}"
    }
  )
}

resource "aws_sns_topic_policy" "infrastructure_alerts" {
  arn = aws_sns_topic.infrastructure_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudWatchAlarms"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action = "SNS:Publish"
        Resource = aws_sns_topic.infrastructure_alerts.arn
      }
    ]
  })
}

# CloudWatch Dashboard for HR Documents Monitoring
resource "aws_cloudwatch_dashboard" "hr_documents" {
  dashboard_name = "hr-documents-dashboard-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/S3", "BucketSizeBytes", { stat = "Average" }],
            [".", "NumberOfObjects", { stat = "Average" }]
          ]
          period = 86400
          stat   = "Average"
          region = var.aws_region
          title  = "S3 Bucket Storage"
          yAxis = {
            left = {
              label = "Bytes"
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/S3", "AllRequests", { stat = "Sum" }],
            [".", "GetRequests", { stat = "Sum" }],
            [".", "PutRequests", { stat = "Sum" }],
            [".", "DeleteRequests", { stat = "Sum" }]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "S3 API Requests"
          yAxis = {
            left = {
              label = "Count"
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/S3", "4xxErrors", { stat = "Sum" }],
            [".", "5xxErrors", { stat = "Sum" }]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "S3 Request Errors"
          yAxis = {
            left = {
              label = "Error Count"
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["HR-Documents-Security", "UnauthorizedAccessCount", { stat = "Sum" }]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "Unauthorized Access Attempts"
          yAxis = {
            left = {
              label = "Count"
            }
          }
        }
      }
    ]
  })
}

# Alarm: Unauthorized access attempts (> 5 in 5 minutes)
resource "aws_cloudwatch_metric_alarm" "unauthorized_access" {
  count = var.enable_cloudtrail_logging ? 1 : 0
  alarm_name          = "hr-documents-unauthorized-access-${var.environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnauthorizedAccessCount"
  namespace           = "HR-Documents-Security"
  period              = "300"
  statistic           = "Sum"
  threshold           = "5"
  alarm_description   = "Alert when unauthorized S3 access attempts exceed 5 in 5 minutes"
  alarm_actions       = [aws_sns_topic.infrastructure_alerts.arn]

  tags = merge(
    var.tags,
    {
      Name = "unauthorized-access-alarm-${var.environment}"
    }
  )
}

# Alarm: Bucket size approaching quota (> 900 GB of 1 TB)
resource "aws_cloudwatch_metric_alarm" "bucket_size_quota" {
  alarm_name          = "hr-documents-bucket-size-quota-${var.environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "BucketSizeBytes"
  namespace           = "AWS/S3"
  period              = "86400"
  statistic           = "Average"
  threshold           = "964516425728"  # 900 GB in bytes
  alarm_description   = "Alert when S3 bucket size approaches 1 TB quota (> 900 GB)"
  alarm_actions       = [aws_sns_topic.infrastructure_alerts.arn]

  dimensions = {
    BucketName = aws_s3_bucket.documents.id
  }

  tags = merge(
    var.tags,
    {
      Name = "bucket-quota-alarm-${var.environment}"
    }
  )
}

# Alarm: Backup/Replication failures
resource "aws_cloudwatch_metric_alarm" "replication_failures" {
  count = var.cross_region_replication_enabled ? 1 : 0
  alarm_name          = "hr-documents-replication-failures-${var.environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ReplicationLatency"
  namespace           = "AWS/S3"
  period              = "900"
  statistic           = "Maximum"
  threshold           = "900000"  # 15 minutes in milliseconds
  alarm_description   = "Alert when S3 replication latency exceeds 15 minutes"
  alarm_actions       = [aws_sns_topic.infrastructure_alerts.arn]

  dimensions = {
    SourceBucket      = aws_s3_bucket.documents.id
    DestinationBucket = aws_s3_bucket.documents_replica.id
  }

  treat_missing_data = "notBreaching"

  tags = merge(
    var.tags,
    {
      Name = "replication-alarm-${var.environment}"
    }
  )
}

# Alarm: S3 4xx errors (access denied, etc.)
resource "aws_cloudwatch_metric_alarm" "s3_4xx_errors" {
  alarm_name          = "hr-documents-s3-4xx-errors-${var.environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "4xxErrors"
  namespace           = "AWS/S3"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "Alert when S3 4xx errors exceed 10 in 5 minutes"
  alarm_actions       = [aws_sns_topic.infrastructure_alerts.arn]

  dimensions = {
    BucketName = aws_s3_bucket.documents.id
  }

  tags = merge(
    var.tags,
    {
      Name = "s3-4xx-errors-alarm-${var.environment}"
    }
  )
}

# Alarm: S3 5xx errors (server errors)
resource "aws_cloudwatch_metric_alarm" "s3_5xx_errors" {
  alarm_name          = "hr-documents-s3-5xx-errors-${var.environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "5xxErrors"
  namespace           = "AWS/S3"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alert when S3 5xx errors occur"
  alarm_actions       = [aws_sns_topic.infrastructure_alerts.arn]

  dimensions = {
    BucketName = aws_s3_bucket.documents.id
  }

  tags = merge(
    var.tags,
    {
      Name = "s3-5xx-errors-alarm-${var.environment}"
    }
  )
}

# Alarm: Object deletions (track delete operations)
resource "aws_cloudwatch_metric_alarm" "object_deletions" {
  count = var.enable_cloudtrail_logging ? 1 : 0
  alarm_name          = "hr-documents-object-deletions-${var.environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DeletionCount"
  namespace           = "HR-Documents-Audit"
  period              = "3600"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alert when S3 objects are deleted (audit trail)"
  alarm_actions       = [aws_sns_topic.infrastructure_alerts.arn]
  treat_missing_data  = "notBreaching"

  tags = merge(
    var.tags,
    {
      Name = "object-deletion-alarm-${var.environment}"
    }
  )
}

# Custom metric for document upload/download volume
resource "aws_cloudwatch_log_group_metric_filter" "upload_volume" {
  count          = var.enable_cloudtrail_logging ? 1 : 0
  name           = "S3UploadVolume"
  log_group_name = aws_cloudwatch_log_group.cloudtrail[0].name
  filter_pattern = "{ ($.eventName = \"PutObject\") }"

  metric_transformation {
    name      = "UploadCount"
    namespace = "HR-Documents-Activity"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_group_metric_filter" "download_volume" {
  count          = var.enable_cloudtrail_logging ? 1 : 0
  name           = "S3DownloadVolume"
  log_group_name = aws_cloudwatch_log_group.cloudtrail[0].name
  filter_pattern = "{ ($.eventName = \"GetObject\") }"

  metric_transformation {
    name      = "DownloadCount"
    namespace = "HR-Documents-Activity"
    value     = "1"
  }
}
