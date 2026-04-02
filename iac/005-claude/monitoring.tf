# CloudWatch Monitoring and Alerting for CloudFront CDN
# Dashboards, alarms, and SNS notifications for cache performance

# SNS Topic for alert notifications
resource "aws_sns_topic" "blog_cdn_alerts" {
  name              = "blog-cdn-alerts-${var.environment}"
  display_name      = "Blog CDN Alerts"
  kms_master_key_id = "alias/aws/sns"

  tags = {
    Name = "blog-cdn-alerts"
  }
}

# SNS Topic Subscription (email)
resource "aws_sns_topic_subscription" "blog_cdn_alerts_email" {
  topic_arn = aws_sns_topic.blog_cdn_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# CloudWatch Dashboard for CDN Monitoring
resource "aws_cloudwatch_dashboard" "blog_cdn" {
  dashboard_name = "blog-cdn-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/CloudFront", "CacheHitRate", { stat = "Average" }],
            [".", "Requests", { stat = "Sum" }],
            [".", "BytesDownloaded", { stat = "Sum" }],
            [".", "BytesUploaded", { stat = "Sum" }],
            [".", "4xxErrorRate", { stat = "Average" }],
            [".", "5xxErrorRate", { stat = "Average" }]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "CloudFront Distribution Overview"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/CloudFront", "OriginLatency", { stat = "p50", label = "P50" }],
            ["...", { stat = "p95", label = "P95" }],
            ["...", { stat = "p99", label = "P99" }]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "Origin Latency (p50, p95, p99)"
          yAxis = {
            left = {
              min = 0
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/CloudFront", "Requests", { stat = "Sum", dimensions = { DistributionId = aws_cloudfront_distribution.blog_cdn.id } }],
            ["...", { stat = "Sum", dimensions = { DistributionId = aws_cloudfront_distribution.blog_cdn.id, Region = "us-east-1" }, label = "US-East" }],
            ["...", { stat = "Sum", dimensions = { DistributionId = aws_cloudfront_distribution.blog_cdn.id, Region = "eu-west-1" }, label = "EU-West" }],
            ["...", { stat = "Sum", dimensions = { DistributionId = aws_cloudfront_distribution.blog_cdn.id, Region = "ap-northeast-1" }, label = "Asia-Pacific" }]
          ]
          period = 300
          stat   = "Sum"
          region = "us-east-1"
          title  = "Requests by Geographic Region"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/CloudFront", "CacheHitRate", { stat = "Average" }]
          ]
          period = 60
          stat   = "Average"
          region = "us-east-1"
          title  = "Cache Hit Rate (1-minute resolution)"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      }
    ]
  })

  depends_on = [aws_cloudfront_distribution.blog_cdn]
}

# CloudWatch Alarm: Cache Hit Ratio below threshold
resource "aws_cloudwatch_metric_alarm" "cache_hit_ratio" {
  alarm_name          = "blog-cdn-cache-hit-ratio-${var.environment}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CacheHitRate"
  namespace           = "AWS/CloudFront"
  period              = "300"
  statistic           = "Average"
  threshold           = var.cache_hit_alert_threshold
  alarm_description   = "Alert when cache hit ratio drops below ${var.cache_hit_alert_threshold}% (may indicate cache misconfiguration or increased origin changes)"
  alarm_actions       = [aws_sns_topic.blog_cdn_alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    DistributionId = aws_cloudfront_distribution.blog_cdn.id
  }

  tags = {
    Name = "blog-cdn-cache-hit-ratio-alarm"
  }
}

# CloudWatch Alarm: P95 Latency above threshold
resource "aws_cloudwatch_metric_alarm" "latency_p95" {
  alarm_name          = "blog-cdn-latency-p95-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "OriginLatency"
  namespace           = "AWS/CloudFront"
  period              = "300"
  extended_statistic  = "p95"
  threshold           = var.latency_alert_threshold
  alarm_description   = "Alert when 95th percentile latency exceeds ${var.latency_alert_threshold}ms (performance degradation detected)"
  alarm_actions       = [aws_sns_topic.blog_cdn_alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    DistributionId = aws_cloudfront_distribution.blog_cdn.id
  }

  tags = {
    Name = "blog-cdn-latency-p95-alarm"
  }
}

# CloudWatch Alarm: 4xx Error Rate
resource "aws_cloudwatch_metric_alarm" "error_rate_4xx" {
  alarm_name          = "blog-cdn-error-rate-4xx-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "4xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = "300"
  statistic           = "Average"
  threshold           = 1.0 # 1% error rate
  alarm_description   = "Alert when 4xx error rate exceeds 1% (client errors - investigate origin or cache configuration)"
  alarm_actions       = [aws_sns_topic.blog_cdn_alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    DistributionId = aws_cloudfront_distribution.blog_cdn.id
  }

  tags = {
    Name = "blog-cdn-error-rate-4xx-alarm"
  }
}

# CloudWatch Alarm: 5xx Error Rate
resource "aws_cloudwatch_metric_alarm" "error_rate_5xx" {
  alarm_name          = "blog-cdn-error-rate-5xx-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "5xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = "300"
  statistic           = "Average"
  threshold           = 1.0 # 1% error rate
  alarm_description   = "Alert when 5xx error rate exceeds 1% (origin errors - origin server or health check misconfiguration)"
  alarm_actions       = [aws_sns_topic.blog_cdn_alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    DistributionId = aws_cloudfront_distribution.blog_cdn.id
  }

  tags = {
    Name = "blog-cdn-error-rate-5xx-alarm"
  }
}

# CloudWatch Alarm: Requests per minute (baseline tracking, no alarm)
resource "aws_cloudwatch_metric_alarm" "requests_high" {
  alarm_name          = "blog-cdn-requests-high-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "3"
  metric_name         = "Requests"
  namespace           = "AWS/CloudFront"
  period              = "60"
  statistic           = "Sum"
  threshold           = 100000 # 100k requests in 60 seconds
  alarm_description   = "Alert when request rate exceeds 100k/minute (unusual traffic spike)"
  alarm_actions       = [aws_sns_topic.blog_cdn_alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    DistributionId = aws_cloudfront_distribution.blog_cdn.id
  }

  tags = {
    Name = "blog-cdn-requests-high-alarm"
  }
}

# Outputs consolidated in outputs.tf
