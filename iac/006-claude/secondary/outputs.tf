# Primary Region Outputs

# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = try(aws_vpc.main.id, "")
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = try(aws_vpc.main.cidr_block, "")
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = try(aws_subnet.public[*].id, [])
}

output "private_app_subnet_ids" {
  description = "IDs of private application subnets"
  value       = try(aws_subnet.private_app[*].id, [])
}

output "private_db_subnet_ids" {
  description = "IDs of private database subnets"
  value       = try(aws_subnet.private_db[*].id, [])
}

# ALB Outputs
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = try(aws_lb.main.dns_name, "")
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = try(aws_lb.main.arn, "")
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = try(aws_lb_target_group.main.arn, "")
}

# RDS Aurora Outputs
output "rds_cluster_identifier" {
  description = "RDS cluster identifier"
  value       = try(aws_rds_cluster.main.id, "")
}

output "rds_cluster_endpoint" {
  description = "RDS cluster endpoint (writer)"
  value       = try(aws_rds_cluster.main.endpoint, "")
}

output "rds_reader_endpoint" {
  description = "RDS cluster reader endpoint"
  value       = try(aws_rds_cluster.main.reader_endpoint, "")
}

output "rds_cluster_arn" {
  description = "RDS cluster ARN"
  value       = try(aws_rds_cluster.main.arn, "")
}

# Auto Scaling Group Outputs
output "asg_name" {
  description = "Auto Scaling Group name"
  value       = try(aws_autoscaling_group.main.name, "")
}

output "asg_min_size" {
  description = "Minimum size of Auto Scaling Group"
  value       = try(aws_autoscaling_group.main.min_size, "")
}

output "asg_max_size" {
  description = "Maximum size of Auto Scaling Group"
  value       = try(aws_autoscaling_group.main.max_size, "")
}

# Security Group Outputs
output "alb_security_group_id" {
  description = "Security group ID for ALB"
  value       = try(aws_security_group.alb.id, "")
}

output "app_instance_security_group_id" {
  description = "Security group ID for application instances"
  value       = try(aws_security_group.app_instance.id, "")
}

output "rds_security_group_id" {
  description = "Security group ID for RDS"
  value       = try(aws_security_group.rds.id, "")
}

# CloudWatch Outputs
output "cloudwatch_log_group" {
  description = "CloudWatch log group for application instances"
  value       = try(aws_cloudwatch_log_group.app_instances.name, "")
}

# Deployment Information
output "deployment_region" {
  description = "Primary deployment region"
  value       = var.aws_region
}

output "deployment_environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "terraform_version" {
  description = "Terraform version constraint"
  value       = ">= 1.14.0"
}

# Next Steps
output "setup_instructions" {
  description = "Setup instructions for deployment"
  value       = <<-EOT
    ## Primary Region (eu-central-1) Deployment Steps:

    1. Initialize Terraform:
       cd iac/primary
       terraform init

    2. Review planned changes:
       terraform plan -var-file=terraform.tfvars

    3. Apply configuration:
       terraform apply -var-file=terraform.tfvars

    4. Document outputs for application deployment

    5. Next: Deploy secondary region infrastructure:
       cd ../secondary
       terraform init
       terraform plan -var-file=terraform.tfvars
       terraform apply -var-file=terraform.tfvars
  EOT
}
