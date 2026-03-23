# EC2 Image Builder Pipeline with CIS Level 1 Hardening

# ============================================================================
# Image Builder Recipe - Ansible Hardening Component
# ============================================================================

resource "aws_imagebuilder_image_recipe" "hardened_ami" {
  name              = "${var.project_name}-hardened-recipe-${var.environment}"
  parent_image      = "arn:aws:imagebuilder:${var.region}:aws:image/amazonlinux-2023-x86_64/2023.11.0"
  semantic_version  = "1.0.0"
  working_directory = "/tmp/image-building"

  component {
    component_arn = aws_imagebuilder_component.cis_hardening.arn
    parameters {
      name  = "CISLevel"
      value = ["1"]
    }
  }

  tags = {
    Name = "${var.project_name}-hardened-recipe-${var.environment}"
  }
}

# ============================================================================
# Image Builder Component - CIS Level 1 Hardening via Ansible
# ============================================================================

resource "aws_imagebuilder_component" "cis_hardening" {
  name               = "${var.project_name}-cis-level1-component-${var.environment}"
  description        = "CIS Level 1 Benchmarks for Amazon Linux 2023"
  semantic_version   = "1.0.0"
  platform           = "Linux"
  change_description = "Initial CIS Level 1 hardening implementation"

  # Ansible playbook for CIS hardening (embedded)
  data = base64encode(templatefile("${path.module}/playbooks/cis-hardening.yml", {
    environment = var.environment
  }))

  tags = {
    Name = "${var.project_name}-cis-component-${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ============================================================================
# Image Builder Infrastructure Configuration
# ============================================================================

resource "aws_imagebuilder_infrastructure_configuration" "main" {
  name                          = "${var.project_name}-infrastructure-config-${var.environment}"
  instance_profile_name         = aws_iam_instance_profile.imagebuilder.name
  instance_types                = [var.image_builder_instance_type]
  security_group_ids            = [aws_security_group.imagebuilder.id]
  subnet_id                     = aws_subnet.private[0].id
  terminate_instance_on_failure = true
  logging {
    s3_logs {
      s3_bucket_name = aws_s3_bucket.imagebuilder_logs.id
      s3_key_prefix  = "image-builder-logs"
    }
  }

  tags = {
    Name = "${var.project_name}-infrastructure-config-${var.environment}"
  }
}

# S3 bucket for Image Builder logs
resource "aws_s3_bucket" "imagebuilder_logs" {
  bucket = "${var.project_name}-imagebuilder-logs-${var.environment}"

  tags = {
    Name = "${var.project_name}-imagebuilder-logs-${var.environment}"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "imagebuilder_logs" {
  bucket = aws_s3_bucket.imagebuilder_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "imagebuilder_logs" {
  bucket = aws_s3_bucket.imagebuilder_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ============================================================================
# Image Builder Distribution Configuration
# ============================================================================

resource "aws_imagebuilder_distribution_configuration" "main" {
  name = "${var.project_name}-distribution-config-${var.environment}"

  distribution {
    region = var.region

    # Create unencrypted base AMI to S3 for inspection
    s3_export_locations {
      s3_bucket = aws_s3_bucket.image_registry.id
      s3_prefix = "base-images"
    }

    # Encrypted final AMI for deployment
    ami_distribution_configuration {
      name        = "${var.project_name}-cis-hardened-ami-${var.environment}-{{ imagebuilder:buildDate }}"
      description = "CIS Level 1 hardened AMI for ${var.project_name}-${var.environment}"
      ami_tags = {
        Name             = "${var.project_name}-cis-hardened-ami"
        Environment      = var.environment
        CISCompliance    = "Level1"
        BuildDate        = timestamp()
        HardeningVersion = "1.0.0"
      }

      # Enable encryption for final AMI
      kms_key_id = "alias/aws/ebs"
    }
  }

  tags = {
    Name = "${var.project_name}-distribution-config-${var.environment}"
  }
}

# ============================================================================
# Image Builder Pipeline
# ============================================================================

resource "aws_imagebuilder_image_pipeline" "main" {
  name                             = "${var.project_name}-pipeline-${var.environment}"
  description                      = "Hardened AMI pipeline with CIS Level 1 benchmarks"
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.main.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.hardened_ami.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.main.arn
  schedule {
    schedule_expression = var.build_schedule
  }

  # Enable image tests
  image_tests_configuration {
    image_tests_enabled = var.enable_compliance_scanning
    timeout_minutes     = var.build_timeout_minutes
  }

  tags = {
    Name = "${var.project_name}-pipeline-${var.environment}"
  }

  depends_on = [
    aws_iam_role_policy.imagebuilder,
    aws_s3_bucket.image_registry
  ]
}

# ============================================================================
# Outputs
# ============================================================================

output "imagebuilder_pipeline_arn" {
  value       = aws_imagebuilder_image_pipeline.main.arn
  description = "ARN of the Image Builder pipeline"
}

output "imagebuilder_pipeline_name" {
  value       = aws_imagebuilder_image_pipeline.main.name
  description = "Name of the Image Builder pipeline"
}

output "imagebuilder_recipe_arn" {
  value       = aws_imagebuilder_image_recipe.hardened_ami.arn
  description = "ARN of the image recipe"
}
