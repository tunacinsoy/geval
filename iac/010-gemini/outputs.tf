output "image_pipeline_arn" {
  description = "The ARN of the EC2 Image Builder pipeline"
  value       = aws_imagebuilder_image_pipeline.this.arn
}

output "autoscaling_group_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.app_asg.name
}

output "latest_ami_id" {
  description = "The ID of the most recently built hardened AMI"
  value       = data.aws_ami.latest_hardened.id
}