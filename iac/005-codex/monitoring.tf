locals {
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 24
        height = 6
        properties = {
          view    = "timeSeries"
          stacked = false
          metrics = [
            ["AWS/CloudFront", "TotalErrorRate", "DistributionId", aws_cloudfront_distribution.cdn.id],
            ["AWS/CloudFront", "CacheHitRate", "DistributionId", aws_cloudfront_distribution.cdn.id]
          ]
          period = 300
          stat   = "Average"
          title  = "CloudFront health"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_dashboard" "cdn" {
  dashboard_name = "GlobalImageDelivery"
  dashboard_body = local.dashboard_body
}

resource "aws_cloudwatch_metric_alarm" "cache_hit" {
  alarm_name          = "cdn-cache-hit-ratio"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CacheHitRate"
  namespace           = "AWS/CloudFront"
  period              = 300
  statistic           = "Average"
  threshold           = 90
  dimensions = {
    DistributionId = aws_cloudfront_distribution.cdn.id
  }
  alarm_description = "Alert if CloudFront cache hit ratio drops below 90%"
  alarm_actions     = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "tfb_95th" {
  alarm_name          = "cdn-ttfb-95th"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "TotalTime"
  namespace           = "AWS/CloudFront"
  period              = 300
  statistic           = "p95"
  threshold           = 0.35
  dimensions = {
    DistributionId = aws_cloudfront_distribution.cdn.id
  }
  treat_missing_data = "ignore"
  alarm_description  = "95th percentile time to first byte exceeds 350ms"
}
