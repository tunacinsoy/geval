resource "aws_cloudwatch_log_group" "imagebuilder" {
  name              = "/aws/imagebuilder/hardened"
  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "asg" {
  name              = "/aws/autoscaling/hardened"
  retention_in_days = 90
}
