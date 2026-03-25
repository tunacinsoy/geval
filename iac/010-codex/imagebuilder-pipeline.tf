resource "aws_imagebuilder_image_recipe" "hardened" {
  name         = "hardened-al2023"
  version      = "1.0.0"
  parent_image = data.aws_ami.amazon_linux_2023.id
  component {
    component_arn = aws_imagebuilder_component.cis_ansible.arn
  }
  block_device_mapping {
    device_name = "/dev/xvda"
    ebs_device {
      volume_size = 30
      volume_type = "gp3"
    }
  }
  tags = {
    Name = "hardened-image-recipe"
  }
}

resource "aws_imagebuilder_infrastructure_configuration" "main" {
  name = "pipeline-infrastructure"
  instance_types = [var.pipeline_instance_type]
  subnet_id = values(aws_subnet.private)[0].id
  security_group_ids = [aws_security_group.builder.id]
  instance_profile_name = aws_iam_instance_profile.imagebuilder.name
  terminate_instance_on_failure = true
  logging {
    s3_logs {
      s3_bucket_name = aws_s3_bucket.artifacts.bucket
    }
  }
}

resource "aws_imagebuilder_image_pipeline" "hardened" {
  name = "hardened-image-pipeline"
  image_recipe_arn               = aws_imagebuilder_image_recipe.hardened.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.main.arn
  status = "DISABLED"
  schedule {
    schedule_expression = "cron(0 2 ? * SUN *)"
    pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE"
  }
  tags = {
    Name = "hardened-image-pipeline"
  }
}
