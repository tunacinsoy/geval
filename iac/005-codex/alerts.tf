resource "aws_sns_topic" "alerts" {
  name = "global-image-delivery-alerts"
}

resource "aws_cloudwatch_event_rule" "cache_anomaly" {
  name        = "cache-anomaly-rule"
  description = "Captures cache hit anomalies for manual review"
  event_pattern = jsonencode({
    source = ["aws.cloudwatch"],
    detail = {
      alarmName = [
        aws_cloudwatch_metric_alarm.cache_hit.alarm_name,
        aws_cloudwatch_metric_alarm.tfb_95th.alarm_name
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "cache_anomaly" {
  rule = aws_cloudwatch_event_rule.cache_anomaly.name
  arn  = aws_sns_topic.alerts.arn
}
