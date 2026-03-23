# CloudWatch Alarms for Monitoring and Alerting

# ============================================================================
# Build Alarms
# ============================================================================

# Build Failure Alert (Critical)
resource "aws_cloudwatch_metric_alarm" "build_failure" {
  alarm_name          = "${var.project_name}-build-failure-${var.environment}"
  alarm_description   = "Alert on Image Builder pipeline failure"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "SuccessfulImageBuilds"
  namespace           = "ImageBuilder"
  period              = "3600"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "breaching"

  tags = {
    Name = "${var.project_name}-build-failure-${var.environment}"
  }
}

# Build Latency Warning (>25 minutes)
resource "aws_cloudwatch_metric_alarm" "build_latency" {
  alarm_name          = "${var.project_name}-build-latency-${var.environment}"
  alarm_description   = "Warning when image build exceeds 25 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BuildDuration"
  namespace           = "ImageBuilder"
  period              = "60"
  statistic           = "Average"
  threshold           = "1500" # 25 minutes in seconds
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  tags = {
    Name = "${var.project_name}-build-latency-${var.environment}"
  }
}

# ============================================================================
# ASG & Instance Refresh Alarms
# ============================================================================

# ASG Refresh Failure Alert (Critical)
resource "aws_cloudwatch_metric_alarm" "asg_refresh_failure" {
  alarm_name          = "${var.project_name}-refresh-failure-${var.environment}"
  alarm_description   = "Alert on Auto Scaling Group instance refresh failure"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "RefreshFailures"
  namespace           = "AWS/AutoScaling"
  period              = "300"
  statistic           = "Sum"
  threshold           = "0"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  tags = {
    Name = "${var.project_name}-refresh-failure-${var.environment}"
  }
}

# Refresh Latency Warning (>50 minutes for 50-instance fleet)
resource "aws_cloudwatch_metric_alarm" "refresh_latency" {
  alarm_name          = "${var.project_name}-refresh-latency-${var.environment}"
  alarm_description   = "Warning when instance refresh exceeds 50 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "RefreshDuration"
  namespace           = "AWS/AutoScaling"
  period              = "60"
  statistic           = "Average"
  threshold           = "3000" # 50 minutes in seconds
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  tags = {
    Name = "${var.project_name}-refresh-latency-${var.environment}"
  }
}

# ============================================================================
# ALB & Target Health Alarms
# ============================================================================

# Unhealthy Targets Alert (if ALB enabled)
resource "aws_cloudwatch_metric_alarm" "unhealthy_targets" {
  count               = var.enable_alb ? 1 : 0
  alarm_name          = "${var.project_name}-unhealthy-targets-${var.environment}"
  alarm_description   = "Alert when targets become unhealthy"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "0"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.main[0].arn_suffix
    TargetGroup  = aws_lb_target_group.main[0].arn_suffix
  }

  tags = {
    Name = "${var.project_name}-unhealthy-targets-${var.environment}"
  }
}

# ALB Target Response Time Warning (>1 second)
resource "aws_cloudwatch_metric_alarm" "alb_response_time" {
  count               = var.enable_alb ? 1 : 0
  alarm_name          = "${var.project_name}-alb-response-time-${var.environment}"
  alarm_description   = "Warning when ALB target response time > 1 second"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1.0"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.main[0].arn_suffix
  }

  tags = {
    Name = "${var.project_name}-alb-response-time-${var.environment}"
  }
}

# ============================================================================
# Instance Launch Alarms
# ============================================================================

# Instance Launch Failure Alert
resource "aws_cloudwatch_metric_alarm" "launch_failure" {
  alarm_name          = "${var.project_name}-launch-failure-${var.environment}"
  alarm_description   = "Alert on instance launch failures"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "LaunchFailures"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Sum"
  threshold           = "0"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  tags = {
    Name = "${var.project_name}-launch-failure-${var.environment}"
  }
}

# ============================================================================
# Compliance Alarms
# ============================================================================

# CIS Compliance Failure Alert
resource "aws_cloudwatch_metric_alarm" "compliance_failure" {
  alarm_name          = "${var.project_name}-compliance-failure-${var.environment}"
  alarm_description   = "Alert when CIS Level 1 compliance validation fails"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ComplianceFailures"
  namespace           = "ImageBuilder"
  period              = "300"
  statistic           = "Sum"
  threshold           = "0"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  tags = {
    Name = "${var.project_name}-compliance-failure-${var.environment}"
  }
}

# ============================================================================
# Log Group Insights Queries (for debugging)
# ============================================================================

# Note: CloudWatch Insights queries can be added in Phase 4
# These help query build logs for failures, performance analysis, etc.

# Example queries (to be added to documentation):
# - Image build duration: fields @timestamp, @message | filter @message like /Build completed/ | stats avg(@duration)
# - CIS compliance failures: fields @timestamp, @message | filter @message like /FAILED/
# - Instance health check failures: fields @timestamp, @message | filter @message like /Health check failed/

output "alarm_names" {
  value = {
    build_failure      = aws_cloudwatch_metric_alarm.build_failure.alarm_name
    build_latency      = aws_cloudwatch_metric_alarm.build_latency.alarm_name
    refresh_failure    = aws_cloudwatch_metric_alarm.asg_refresh_failure.alarm_name
    refresh_latency    = aws_cloudwatch_metric_alarm.refresh_latency.alarm_name
    compliance_failure = aws_cloudwatch_metric_alarm.compliance_failure.alarm_name
    launch_failure     = aws_cloudwatch_metric_alarm.launch_failure.alarm_name
  }
  description = "Names of all CloudWatch alarms"
}
