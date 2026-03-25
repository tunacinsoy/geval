resource "aws_imagebuilder_component" "ansible_hardening" {
  name     = "ansible-cis-level-1"
  platform = "Linux"
  version  = "1.0.0"

  data = yamlencode({
    schemaVersion = "1.0"
    phases = [{
      name = "build"
      steps = [{
        name   = "apply_ansible_playbook"
        action = "ExecuteBash"
        inputs = {
          commands = [
            "sudo dnf install -y ansible",
            "aws s3 cp ${var.ansible_playbook_uri} /tmp/playbook.yml",
            "ansible-playbook /tmp/playbook.yml"
          ]
        }
      }]
    }]
  })
}

resource "aws_imagebuilder_image_recipe" "hardened_al2023" {
  name         = "hardened-al2023-recipe"
  parent_image = "arn:aws:imagebuilder:${var.aws_region}:aws:image/amazon-linux-2023-x86/x.x.x"
  version      = "1.0.0"

  component {
    component_arn = aws_imagebuilder_component.ansible_hardening.arn
  }
}

resource "aws_imagebuilder_infrastructure_configuration" "this" {
  name                  = "hardened-al2023-infra-config"
  instance_profile_name = aws_iam_instance_profile.image_builder_profile.name
  instance_types        = ["t3.medium"]
  subnet_id             = data.aws_subnet.build_subnet.id
  security_group_ids    = [aws_security_group.image_builder_sg.id]
}

resource "aws_imagebuilder_distribution_configuration" "this" {
  name = "hardened-al2023-dist-config"
  distribution {
    region = var.aws_region
    ami_distribution_configuration {
      name = "hardened-al2023-{{ imagebuilder:buildDate }}"
    }
  }
}

resource "aws_imagebuilder_image_pipeline" "this" {
  name                             = "hardened-al2023-pipeline"
  image_recipe_arn                 = aws_imagebuilder_image_recipe.hardened_al2023.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.this.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.this.arn

  schedule {
    schedule_expression = "cron(0 0 ? * SUN *)"
  }
}