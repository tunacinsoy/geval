output "image_pipeline" {
  value = aws_imagebuilder_image_pipeline.hardened.name
}

output "latest_hardened_ami_ssm" {
  value = aws_ssm_parameter.latest_ami.name
}

output "launch_template_id" {
  value = aws_launch_template.hardened.id
}

output "autoscaling_group" {
  value = aws_autoscaling_group.app.name
}
