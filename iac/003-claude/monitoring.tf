# CloudWatch Log Group for Application Logs
resource "aws_cloudwatch_log_group" "app" {
  name              = "/test-playground/app"
  retention_in_days = 7  # Keep logs for 7 days (test environment)

  tags = merge(
    local.common_tags,
    {
      Name = "/test-playground/app"
    }
  )
}

# CloudWatch Log Group for RDS Logs
resource "aws_cloudwatch_log_group" "rds" {
  name              = "/test-playground/rds"
  retention_in_days = 7

  tags = merge(
    local.common_tags,
    {
      Name = "/test-playground/rds"
    }
  )
}

# CloudWatch Log Group for System Logs
resource "aws_cloudwatch_log_group" "system" {
  name              = "/test-playground/system"
  retention_in_days = 7

  tags = merge(
    local.common_tags,
    {
      Name = "/test-playground/system"
    }
  )
}

# CloudWatch Log Group for Docker Logs
resource "aws_cloudwatch_log_group" "docker" {
  name              = "/test-playground/docker"
  retention_in_days = 7

  tags = merge(
    local.common_tags,
    {
      Name = "/test-playground/docker"
    }
  )
}

# CloudWatch Alarm - High RDS CPU Usage (optional, can be added post-launch)
# Uncomment to enable RDS monitoring
# resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
#   alarm_name          = "${local.resource_prefix}-rds-cpu-alarm"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/RDS"
#   period              = 300
#   statistic           = "Average"
#   threshold           = 80
#   alarm_description   = "Alert when RDS CPU exceeds 80%"
#   alarm_actions       = [aws_sns_topic.alerts.arn]
#
#   dimensions = {
#     DBInstanceIdentifier = aws_db_instance.main.identifier
#   }
# }

# CloudWatch Alarm - High EC2 CPU Usage (optional, can be added post-launch)
# Uncomment to enable EC2 monitoring
# resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
#   count               = local.instance_count
#   alarm_name          = "${local.resource_prefix}-ec2-cpu-alarm-${count.index + 1}"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 300
#   statistic           = "Average"
#   threshold           = 80
#   alarm_description   = "Alert when EC2 CPU exceeds 80%"
#
#   dimensions = {
#     InstanceId = aws_instance.app[count.index].id
#   }
# }

# SNS Topic for Alarms (optional, for alert notifications)
# Uncomment to enable SNS notifications
# resource "aws_sns_topic" "alerts" {
#   name = "${local.resource_prefix}-alerts"
#
#   tags = merge(
#     local.common_tags,
#     {
#       Name = "${local.resource_prefix}-alerts"
#     }
#   )
# }

# Outputs
output "app_log_group_name" {
  description = "CloudWatch Log Group for application logs"
  value       = aws_cloudwatch_log_group.app.name
}

output "rds_log_group_name" {
  description = "CloudWatch Log Group for RDS logs"
  value       = aws_cloudwatch_log_group.rds.name
}

output "system_log_group_name" {
  description = "CloudWatch Log Group for system logs"
  value       = aws_cloudwatch_log_group.system.name
}

output "docker_log_group_name" {
  description = "CloudWatch Log Group for Docker logs"
  value       = aws_cloudwatch_log_group.docker.name
}
