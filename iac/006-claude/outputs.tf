# Primary Region Outputs

output "primary_vpc_id" {
  description = "Primary VPC ID"
  value       = aws_vpc.primary.id
}

output "primary_alb_dns" {
  description = "Primary ALB DNS name"
  value       = aws_lb.primary.dns_name
}

output "primary_rds_endpoint" {
  description = "Primary RDS cluster endpoint"
  value       = aws_rds_cluster.primary.endpoint
}

output "primary_asg_name" {
  description = "Primary Auto Scaling Group name"
  value       = aws_autoscaling_group.primary.name
}

# Secondary Region Outputs

output "secondary_vpc_id" {
  description = "Secondary VPC ID"
  value       = aws_vpc.secondary.id
}

output "secondary_alb_dns" {
  description = "Secondary ALB DNS name"
  value       = aws_lb.secondary.dns_name
}

output "secondary_rds_endpoint" {
  description = "Secondary RDS cluster endpoint"
  value       = aws_rds_cluster.secondary.endpoint
}

output "secondary_asg_name" {
  description = "Secondary Auto Scaling Group name"
  value       = aws_autoscaling_group.secondary.name
}

# Deployment Information

output "deployment_info" {
  description = "Deployment configuration summary"
  value = {
    primary_region   = var.primary_region
    secondary_region = var.secondary_region
    vpc_cidr         = var.vpc_cidr
    instance_type    = var.instance_type
    db_instance_class = var.db_instance_class
  }
}
