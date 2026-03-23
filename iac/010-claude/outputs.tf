# Infrastructure Outputs
# Note: Outputs are organized within their respective resource files for modularity
# This file contains consolidated views and deployment information only

# ============================================================================
# VPC & Network Outputs
# ============================================================================

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC ID"
}

output "vpc_cidr" {
  value       = aws_vpc.main.cidr_block
  description = "VPC CIDR block"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "Public subnet IDs (ALB tier)"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "Private subnet IDs (ASG instances tier)"
}

output "nat_gateway_ips" {
  value       = aws_eip.nat[*].public_ip
  description = "Public IPs of NAT Gateways"
}

# ============================================================================
# Security Outputs
# ============================================================================

output "alb_security_group_id" {
  value       = try(aws_security_group.alb[0].id, "ALB disabled")
  description = "ALB security group ID"
}

output "asg_security_group_id" {
  value       = aws_security_group.asg_instances.id
  description = "ASG instances security group ID"
}

output "imagebuilder_security_group_id" {
  value       = aws_security_group.imagebuilder.id
  description = "Image Builder security group ID"
}

# ============================================================================
# IAM Role Outputs
# ============================================================================

output "imagebuilder_role_arn" {
  value       = aws_iam_role.imagebuilder_service.arn
  description = "ARN of Image Builder service role"
}

output "asg_instance_role_arn" {
  value       = aws_iam_role.asg_instance.arn
  description = "ARN of ASG instance role"
}

output "cicd_deployment_role_arn" {
  value       = aws_iam_role.cicd_deployment.arn
  description = "ARN of CI/CD deployment role"
}

output "monitoring_audit_role_arn" {
  value       = aws_iam_role.monitoring_audit.arn
  description = "ARN of Monitoring/Audit read-only role"
}

# ============================================================================
# Storage Outputs
# ============================================================================

output "image_registry_bucket" {
  value       = aws_s3_bucket.image_registry.bucket
  description = "S3 bucket name for hardened AMI images"
}

output "audit_logs_bucket" {
  value       = aws_s3_bucket.audit_logs.bucket
  description = "S3 bucket name for audit logs (GDPR compliance)"
}

output "terraform_backup_bucket" {
  value       = aws_s3_bucket.terraform_state_backup.bucket
  description = "S3 bucket name for Terraform state backups"
}

# ============================================================================
# Deployment Information
# ============================================================================

output "environment" {
  value       = var.environment
  description = "Deployment environment"
}

output "region" {
  value       = var.region
  description = "AWS region"
}

output "account_id" {
  value       = data.aws_caller_identity.current.account_id
  description = "AWS account ID"
}

# ============================================================================
# Deployment Instructions
# ============================================================================

output "deployment_info" {
  value = {
    next_steps = [
      "1. Review terraform plan: terraform plan -var-file=terraform.tfvars.${var.environment}",
      "2. Apply infrastructure: terraform apply -var-file=terraform.tfvars.${var.environment}",
      "3. Get outputs: terraform output",
      "4. Subscribe to SNS topics for build/refresh notifications",
      "5. Configure health check endpoint on instances (/health/ready on port 8080)",
      "6. Trigger first image build: aws imagebuilder start-image-pipeline-execution --image-pipeline-arn <pipeline-arn>",
      "7. Monitor build progress: aws logs tail /aws/imagebuilder/${var.project_name}-pipeline-${var.environment}",
      "8. Trigger instance refresh: aws autoscaling start-instance-refresh --auto-scaling-group-name <asg-name>"
    ]
  }
  description = "Next steps for deploying infrastructure"
}
