# CloudWatch Log Groups for Monitoring and Audit Trail

# ============================================================================
# Image Builder Logs
# ============================================================================

resource "aws_cloudwatch_log_group" "imagebuilder" {
  name              = "/aws/imagebuilder/${var.project_name}-pipeline-${var.environment}"
  retention_in_days = var.log_retention_days

  tags = {
    Name = "${var.project_name}-imagebuilder-logs-${var.environment}"
  }
}

resource "aws_cloudwatch_log_group" "compliance_validation" {
  name              = "/aws/imagebuilder/compliance-validation-${var.environment}"
  retention_in_days = var.log_retention_days

  tags = {
    Name = "${var.project_name}-compliance-logs-${var.environment}"
  }
}

# ============================================================================
# Auto Scaling Group Operations Logs
# ============================================================================

resource "aws_cloudwatch_log_group" "asg_operations" {
  name              = "/aws/autoscaling/${var.project_name}-asg-${var.environment}"
  retention_in_days = var.log_retention_days

  tags = {
    Name = "${var.project_name}-asg-operations-logs-${var.environment}"
  }
}

# ============================================================================
# Application Instance Logs
# ============================================================================

resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/applicationinstances/${var.project_name}-${var.environment}"
  retention_in_days = var.log_retention_days

  tags = {
    Name = "${var.project_name}-application-logs-${var.environment}"
  }
}

# ============================================================================
# SNS Topics for Notifications
# ============================================================================

resource "aws_sns_topic" "build_notifications" {
  name              = "${var.project_name}-build-notifications-${var.environment}"
  display_name      = "Image Builder Build Notifications"
  kms_master_key_id = "alias/aws/sns"

  tags = {
    Name = "${var.project_name}-build-notifications-${var.environment}"
  }
}

resource "aws_sns_topic" "refresh_notifications" {
  name              = "${var.project_name}-refresh-notifications-${var.environment}"
  display_name      = "Auto Scaling Group Refresh Notifications"
  kms_master_key_id = "alias/aws/sns"

  tags = {
    Name = "${var.project_name}-refresh-notifications-${var.environment}"
  }
}

resource "aws_sns_topic" "alerts" {
  name              = "${var.project_name}-alerts-${var.environment}"
  display_name      = "Infrastructure Alerts"
  kms_master_key_id = "alias/aws/sns"

  tags = {
    Name = "${var.project_name}-alerts-${var.environment}"
  }
}

# ============================================================================
# EventBridge Rule for Scheduled Image Builds
# ============================================================================

resource "aws_cloudwatch_event_rule" "scheduled_image_build" {
  name                = "${var.project_name}-scheduled-build-${var.environment}"
  description         = "Scheduled image build (nightly 2 AM UTC)"
  schedule_expression = "cron(${var.build_schedule})"
  is_enabled          = true

  tags = {
    Name = "${var.project_name}-scheduled-build-${var.environment}"
  }
}

resource "aws_cloudwatch_event_target" "scheduled_image_build" {
  rule     = aws_cloudwatch_event_rule.scheduled_image_build.name
  arn      = "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_sns_topic.build_notifications.name}"
  role_arn = aws_iam_role.eventbridge_service.arn

  # SNS message formatting
  input_transformer {
    input_paths = {
      source = "$.source"
      detail = "$.detail"
    }
    input_template = jsonencode({
      Message = "Scheduled image build triggered for ${var.project_name}-${var.environment}"
      Time    = "$.time"
    })
  }
}

# IAM Role for EventBridge Service
resource "aws_iam_role" "eventbridge_service" {
  name = "${var.project_name}-eventbridge-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-eventbridge-role-${var.environment}"
  }
}

resource "aws_iam_role_policy" "eventbridge_service" {
  name = "${var.project_name}-eventbridge-policy"
  role = aws_iam_role.eventbridge_service.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = aws_sns_topic.build_notifications.arn
      }
    ]
  })
}

# ============================================================================
# Outputs
# ============================================================================

output "sns_build_topic_arn" {
  value       = aws_sns_topic.build_notifications.arn
  description = "SNS topic ARN for build notifications"
}

output "sns_refresh_topic_arn" {
  value       = aws_sns_topic.refresh_notifications.arn
  description = "SNS topic ARN for refresh notifications"
}

output "sns_alerts_topic_arn" {
  value       = aws_sns_topic.alerts.arn
  description = "SNS topic ARN for infrastructure alerts"
}

output "imagebuilder_log_group" {
  value       = aws_cloudwatch_log_group.imagebuilder.name
  description = "CloudWatch Log Group for Image Builder"
}

output "asg_operations_log_group" {
  value       = aws_cloudwatch_log_group.asg_operations.name
  description = "CloudWatch Log Group for ASG operations"
}
