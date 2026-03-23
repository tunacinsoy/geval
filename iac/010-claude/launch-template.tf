# Launch Template for Auto Scaling Group

# Data source to fetch latest hardened AMI from Image Builder registry
data "aws_ami" "hardened_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["${var.project_name}-cis-hardened-ami-${var.environment}-*"]
  }

}

# Launch Template
resource "aws_launch_template" "main" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = data.aws_ami.hardened_ami.id
  instance_type = var.asg_instance_type
  key_name      = aws_key_pair.deployment.key_name
  iam_instance_profile {
    arn = aws_iam_instance_profile.asg_instance.arn
  }

  vpc_security_group_ids = [aws_security_group.asg_instances.id]

  # Root volume configuration
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = "alias/aws/ebs"
      iops                  = 3000
      throughput            = 125
    }
  }

  # Metadata options for IMDSv2 enforcement
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  # User data for application startup (health check endpoint setup, logging, etc.)
  user_data = base64encode(templatefile("${path.module}/scripts/user-data.sh", {
    environment = var.environment
    log_group   = aws_cloudwatch_log_group.application.name
    region      = var.region
  }))

  # Monitoring enabled
  monitoring {
    enabled = true
  }

  # CPU credit specification for burstable instances
  credit_specification {
    cpu_credits = "unlimited"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-instance-${var.environment}"
      Environment = var.environment
      LaunchedAt  = timestamp()
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name        = "${var.project_name}-volume-${var.environment}"
      Environment = var.environment
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# EC2 Key Pair for SSH access (deployment purposes)
resource "aws_key_pair" "deployment" {
  key_name   = "${var.project_name}-deployment-${var.environment}"
  public_key = file("${path.module}/keys/deployment.pub")

  tags = {
    Name = "${var.project_name}-deployment-key-${var.environment}"
  }
}

# ============================================================================
# Outputs
# ============================================================================

output "launch_template_id" {
  value       = aws_launch_template.main.id
  description = "ID of the launch template"
}

output "launch_template_latest_version" {
  value       = aws_launch_template.main.latest_version_number
  description = "Latest version number of the launch template"
}

output "hardened_ami_id" {
  value       = data.aws_ami.hardened_ami.id
  description = "ID of the latest hardened AMI"
}
