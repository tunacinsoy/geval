data "aws_ami" "latest_hardened" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["hardened-al2023-*"]
  }

  depends_on = [aws_imagebuilder_image_pipeline.this]
}

resource "aws_launch_template" "app_template" {
  name_prefix   = "app-node-"
  image_id      = data.aws_ami.latest_hardened.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.app_instance_profile.name
  }

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                = "app-cluster-asg"
  vpc_zone_identifier = var.private_subnet_ids
  desired_capacity    = 12
  min_size            = 12
  max_size            = 24

  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 100
      instance_warmup        = 300
    }
  }

  tag {
    key                 = "Name"
    value               = "app-node"
    propagate_at_launch = true
  }
}