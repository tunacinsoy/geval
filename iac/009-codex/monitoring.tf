resource "aws_cloudwatch_log_metric_filter" "servfail" {
  name           = "CorpInternalSERVFAIL"
  log_group_name = aws_cloudwatch_log_group.resolver.name
  pattern        = "SERVFAIL"

  metric_transformation {
    name      = "CorpInternalServfailCount"
    namespace = "ResolverBridge"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "servfail_alarm" {
  alarm_name          = "CorpInternalSERVFAIL"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  period              = 300
  namespace           = aws_cloudwatch_log_metric_filter.servfail.metric_transformation[0].namespace
  metric_name         = aws_cloudwatch_log_metric_filter.servfail.metric_transformation[0].name
  alarm_description   = "Alerts when failed corp.internal queries (SERVFAIL) exceed the threshold"
  treat_missing_data  = "notBreaching"
}

resource "aws_guardduty_detector" "primary" {
  enable = true
}
