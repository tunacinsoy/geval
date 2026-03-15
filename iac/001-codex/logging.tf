resource "aws_sns_topic" "alerts" {
  name = "flower-shop-alerts-${var.environment}"
}

resource "aws_sns_topic_subscription" "ops_email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.deployment_email
}

resource "aws_cloudwatch_metric_alarm" "cloudfront_errors" {
  alarm_name          = "flower-shop-cf-5xx-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "5xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = 300
  statistic           = "Average"
  threshold           = 0.2
  alarm_description   = "Flag when CloudFront returns more than 0.2% server or edge errors"
  dimensions = {
    DistributionId = aws_cloudfront_distribution.site.id
    Region         = "Global"
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
}
