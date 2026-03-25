resource "aws_sns_topic" "alerts" {
  name = "${var.env}-image-pipeline-alerts"
}

resource "aws_sns_topic_policy" "alerts_policy" {
  arn = aws_sns_topic.alerts.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { Service = "events.amazonaws.com" }
        Action = "sns:Publish"
        Resource = aws_sns_topic.alerts.arn
      }
    ]
  })
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_event_rule" "pipeline_failure" {
  name        = "${var.env}-image-builder-failure"
  description = "Capture Image Builder pipeline failures"
  event_pattern = jsonencode({
    source      = ["aws.imagebuilder"]
    detail-type = ["EC2 Image Builder Image State Change"]
    detail = {
      state = {
        status = ["FAILED"]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "sns_failure" {
  rule      = aws_cloudwatch_event_rule.pipeline_failure.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.alerts.arn
}

resource "aws_cloudwatch_event_rule" "critical_vulnerability" {
  name        = "${var.env}-inspector-critical"
  description = "Alert and quarantine on Critical Vulnerabilities"
  event_pattern = jsonencode({
    source      = ["aws.inspector2"]
    detail-type = ["Inspector2 Finding"]
    detail = {
      severity = ["CRITICAL"]
      status   = ["ACTIVE"]
    }
  })
}

resource "aws_cloudwatch_event_target" "sns_critical" {
  rule      = aws_cloudwatch_event_rule.critical_vulnerability.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.alerts.arn
}