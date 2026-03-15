# Get latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Launch Template
resource "aws_launch_template" "app" {
  name_prefix   = "${local.resource_prefix}-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = local.instance_type

  vpc_security_group_ids = [aws_security_group.compute.id]
  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_profile.arn
  }

  # User data script to bootstrap instance
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    environment = local.environment
    project     = local.project_name
    region      = local.aws_region
    rds_endpoint = aws_db_instance.main.endpoint
    s3_bucket   = aws_s3_bucket.test_artifacts.id
  }))

  # Enable detailed monitoring (optional, for additional cost)
  monitoring {
    enabled = false  # Set to true if detailed monitoring needed
  }

  # EBS Volume Configuration
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }

  # Tag instances at launch
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      local.common_tags,
      {
        Name = "${local.resource_prefix}-instance"
      }
    )
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(
      local.common_tags,
      {
        Name = "${local.resource_prefix}-volume"
      }
    )
  }

  depends_on = [
    aws_db_instance.main,
    aws_s3_bucket.test_artifacts
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# EC2 Instances (Manual Provisioning - no auto-scaling for testing simplicity)
# Deploy 1-5 instances based on instance_count variable
resource "aws_instance" "app" {
  count             = local.instance_count
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  subnet_id              = aws_subnet.private.id
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.id
  vpc_security_group_ids = [aws_security_group.compute.id]

  # Ensure proper ordering
  depends_on = [
    aws_nat_gateway.main,
    aws_db_instance.main,
    aws_s3_bucket.test_artifacts
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_prefix}-instance-${count.index + 1}"
      Role = "AppServer"
    }
  )
}

# Optional: EC2 Auto Scaling Group (for ALB use case)
# Uncomment to enable auto-scaling if ALB is configured
# resource "aws_autoscaling_group" "app" {
#   count            = var.enable_alb ? 1 : 0
#   name             = "${local.resource_prefix}-asg"
#   vpc_zone_identifier = [aws_subnet.private.id]
#   target_group_arns   = [aws_lb_target_group.app[0].arn]
#   health_check_type   = "ELB"
#   health_check_grace_period = 300
#
#   min_size         = 1
#   max_size         = local.instance_count
#   desired_capacity = local.instance_count
#
#   launch_template {
#     id      = aws_launch_template.app.id
#     version = "$Latest"
#   }
#
#   tag {
#     key                 = "Name"
#     value               = "${local.resource_prefix}-asg-instance"
#     propagate_at_launch = true
#   }
#
#   depends_on = [aws_lb.app]
# }

# Outputs
output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.app[*].id
}

output "instance_private_ips" {
  description = "Private IPs of the EC2 instances"
  value       = aws_instance.app[*].private_ip
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.app.id
}

output "launch_template_latest_version" {
  description = "Latest version of the launch template"
  value       = aws_launch_template.app.latest_version_number
}
