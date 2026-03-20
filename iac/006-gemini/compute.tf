resource "aws_launch_configuration" "primary" {
  provider        = aws
  name            = "primary-lc"
  image_id        = "ami-0c55b159cbfafe1f0" # Placeholder
  instance_type   = var.app_instance_type
  security_groups = [aws_security_group.app.id]
}

resource "aws_autoscaling_group" "primary" {
  provider                 = aws
  name                     = "primary-asg"
  launch_configuration     = aws_launch_configuration.primary.id
  min_size                 = var.min_app_instances
  max_size                 = var.max_app_instances
  vpc_zone_identifier      = [aws_subnet.primary_private.id]
  target_group_arns        = [aws_lb_target_group.primary.arn]
}

resource "aws_launch_configuration" "dr" {
  provider        = aws.dr
  name            = "dr-lc"
  image_id        = "ami-0c55b159cbfafe1f0" # Placeholder
  instance_type   = var.app_instance_type
  security_groups = [aws_security_group.dr_app.id]
}

resource "aws_autoscaling_group" "dr" {
  provider                 = aws.dr
  name                     = "dr-asg"
  launch_configuration     = aws_launch_configuration.dr.id
  min_size                 = var.min_app_instances
  max_size                 = var.max_app_instances
  vpc_zone_identifier      = [aws_subnet.dr_private.id]
  target_group_arns        = [aws_lb_target_group.dr.arn]
}
