# CloudWatch logging and monitoring for Route 53 Resolver

# CloudWatch log group for DNS query logs
resource "aws_cloudwatch_log_group" "dns_queries" {
  name              = "/aws/route53resolver/dns-queries-${var.environment}"
  retention_in_days = var.dns_query_log_retention
  kms_key_id        = null # Use AWS managed keys for development

  tags = {
    Name = "route53-resolver-dns-queries-${var.environment}"
  }
}

# Log group resource policy to allow Route 53 Resolver service to write logs
resource "aws_cloudwatch_log_resource_policy" "route53_resolver_logs" {
  policy_name = "route53-resolver-logs-policy-${var.environment}"

  policy_text = data.aws_iam_policy_document.route53_resolver_logs.json
}

data "aws_iam_policy_document" "route53_resolver_logs" {
  statement {
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream"
    ]

    principals {
      type        = "Service"
      identifiers = ["route53resolver.amazonaws.com"]
    }

    resources = ["${aws_cloudwatch_log_group.dns_queries.arn}:*"]
  }
}

# CloudWatch Metric Filter: DNS query errors (SERVFAIL responses)
resource "aws_cloudwatch_log_metric_filter" "dns_servfail" {
  count          = var.create_cloudwatch_alarms ? 1 : 0
  name           = "dns-servfail-errors-${var.environment}"
  log_group_name = aws_cloudwatch_log_group.dns_queries.name
  filter_pattern = "[query_timestamp, query_source, query_domain, query_type, response_code = SERVFAIL, ...]"

  metric_transformation {
    name      = "DNSServfailCount"
    namespace = "HybridDNS/Resolver"
    value     = "1"
    dimensions = {
      Environment = var.environment
    }
  }
}

# CloudWatch Metric Filter: DNS query timeout errors
resource "aws_cloudwatch_log_metric_filter" "dns_timeout" {
  count          = var.create_cloudwatch_alarms ? 1 : 0
  name           = "dns-timeout-errors-${var.environment}"
  log_group_name = aws_cloudwatch_log_group.dns_queries.name
  filter_pattern = "[query_timestamp, query_source, query_domain, query_type, response_code = TIMEOUT, ...]"

  metric_transformation {
    name      = "DNSTimeoutCount"
    namespace = "HybridDNS/Resolver"
    value     = "1"
    dimensions = {
      Environment = var.environment
    }
  }
}

# CloudWatch Metric Filter: Total DNS queries
resource "aws_cloudwatch_log_metric_filter" "dns_total_queries" {
  count          = var.create_cloudwatch_alarms ? 1 : 0
  name           = "dns-total-queries-${var.environment}"
  log_group_name = aws_cloudwatch_log_group.dns_queries.name
  filter_pattern = "[...]" # Match all log events

  metric_transformation {
    name      = "DNSTotalQueries"
    namespace = "HybridDNS/Resolver"
    value     = "1"
    dimensions = {
      Environment = var.environment
    }
  }
}

# CloudWatch Dashboard for DNS resolver monitoring
resource "aws_cloudwatch_dashboard" "dns_resolver" {
  count          = var.create_cloudwatch_alarms ? 1 : 0
  dashboard_name = "hybrid-dns-resolver-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["HybridDNS/Resolver", "DNSTotalQueries", { stat = "Sum", label = "Total Queries" }],
            [".", "DNSServfailCount", { stat = "Sum", label = "SERVFAIL Errors" }],
            [".", "DNSTimeoutCount", { stat = "Sum", label = "Timeout Errors" }]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "DNS Query Metrics"
          yAxis = {
            left = {
              min = 0
            }
          }
        }
      },
      {
        type = "log"
        properties = {
          query  = "fields @timestamp, query_domain, response_code | stats count() by response_code"
          region = var.aws_region
          title  = "Queries by Response Code"
        }
      }
    ]
  })
}

# SNS topic for alarm notifications
resource "aws_sns_topic" "resolver_alarms" {
  count = var.create_cloudwatch_alarms ? 1 : 0
  name  = "hybrid-dns-resolver-alarms-${var.environment}"

  tags = {
    Name = "hybrid-dns-resolver-alarms-${var.environment}"
  }
}

# SNS topic subscription (manual confirmation required)
resource "aws_sns_topic_subscription" "resolver_alarms_email" {
  count     = var.create_cloudwatch_alarms ? 1 : 0
  topic_arn = aws_sns_topic.resolver_alarms[0].arn
  protocol  = "email"
  endpoint  = "infrastructure-team@example.com" # Replace with actual email
}

# CloudWatch Alarm: High error rate (SERVFAIL + TIMEOUT > 1%)
resource "aws_cloudwatch_metric_alarm" "high_error_rate" {
  count               = var.create_cloudwatch_alarms ? 1 : 0
  alarm_name          = "hybrid-dns-high-error-rate-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  threshold           = "1"
  alarm_description   = "Alert when DNS query error rate exceeds 1%"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.resolver_alarms[0].arn]

  metric_query {
    id          = "e1"
    expression  = "(m1 + m2) / m3 * 100"
    label       = "Error Rate (%)"
    return_data = true
  }

  metric_query {
    id = "m1"
    metric {
      metric_name = "DNSServfailCount"
      namespace   = "HybridDNS/Resolver"
      stat        = "Sum"
      period      = 300
      dimensions = {
        Environment = var.environment
      }
    }
  }

  metric_query {
    id = "m2"
    metric {
      metric_name = "DNSTimeoutCount"
      namespace   = "HybridDNS/Resolver"
      stat        = "Sum"
      period      = 300
      dimensions = {
        Environment = var.environment
      }
    }
  }

  metric_query {
    id = "m3"
    metric {
      metric_name = "DNSTotalQueries"
      namespace   = "HybridDNS/Resolver"
      stat        = "Sum"
      period      = 300
      dimensions = {
        Environment = var.environment
      }
    }
  }
}
