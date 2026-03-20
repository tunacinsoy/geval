resource "aws_cloudwatch_dashboard" "main" {
  provider       = aws
  dashboard_name = "main-dashboard"
  dashboard_body = <<EOF
{
  "widgets": []
}
EOF
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  provider            = aws
  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.primary.name
  }
}
