locals {
  expiration_date = timeadd(timestamp(), format("%sd", var.expiration_days))
}

resource "aws_cloudwatch_event_rule" "teardown" {
  name                = "playground-teardown-schedule"
  schedule_expression = "rate(1 day)"
  description         = "Daily reminder to tear down the playground after the expiration date"
}

resource "aws_cloudwatch_event_target" "teardown_alert" {
  rule = aws_cloudwatch_event_rule.teardown.name
  arn  = aws_sns_topic.teardown.arn

  input = jsonencode({
    message = "Playground expires on ${local.expiration_date}. Evaluate extending or destroying the stack."
  })
}

resource "aws_sns_topic" "teardown" {
  name = "playground-teardown-alert"
}

resource "aws_sns_topic_subscription" "team" {
  topic_arn = aws_sns_topic.teardown.arn
  protocol  = "email"
  endpoint  = "feature-team@example.com"
}

resource "aws_sns_topic_policy" "teardown" {
  arn = aws_sns_topic.teardown.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowEventBridge"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action = "sns:Publish"
        Resource = aws_sns_topic.teardown.arn
      }
    ]
  })
}
