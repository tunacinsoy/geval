# ============================================================================
# TERRAFORM OUTPUTS - CRITICAL INFRASTRUCTURE INFORMATION
# ============================================================================
# These outputs contain important connection information for the test
# environment. Save these values after running 'terraform apply'.

# ============================================================================
# VPC & NETWORKING
# ============================================================================

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "Private subnet ID"
  value       = aws_subnet.private.id
}

output "nat_gateway_public_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

# ============================================================================
# RDS DATABASE CONNECTION
# ============================================================================

output "rds_endpoint" {
  description = "RDS database endpoint (host:port)"
  value       = aws_db_instance.main.endpoint
  sensitive   = false
}

output "rds_address" {
  description = "RDS database hostname only"
  value       = aws_db_instance.main.address
  sensitive   = false
}

output "rds_port" {
  description = "RDS database port"
  value       = aws_db_instance.main.port
}

output "rds_database_name" {
  description = "RDS database name"
  value       = aws_db_instance.main.db_name
}

output "rds_username" {
  description = "RDS master username"
  value       = aws_db_instance.main.username
  sensitive   = false
}

output "rds_instance_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.main.identifier
}

output "rds_replica_endpoint" {
  description = "RDS replica (standby) endpoint for failover validation"
  value       = aws_db_instance.replica.endpoint
  sensitive   = false
}

# PostgreSQL Connection String (TEMPLATE - replace PASSWORD with actual password)
output "postgresql_connection_string" {
  description = "PostgreSQL connection string template (replace PASSWORD with actual secret)"
  value       = "postgresql://${aws_db_instance.main.username}:PASSWORD@${aws_db_instance.main.address}:${aws_db_instance.main.port}/${aws_db_instance.main.db_name}"
  sensitive   = true
}

# ============================================================================
# S3 STORAGE
# ============================================================================

output "s3_bucket_name" {
  description = "S3 bucket name for test artifacts"
  value       = aws_s3_bucket.test_artifacts.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.test_artifacts.arn
}

output "s3_bucket_regional_domain_name" {
  description = "S3 bucket regional domain name"
  value       = aws_s3_bucket.test_artifacts.bucket_regional_domain_name
}

output "s3_upload_command" {
  description = "Example AWS CLI command to upload file to S3"
  value       = "aws s3 cp <file> s3://${aws_s3_bucket.test_artifacts.id}/ --region ${local.aws_region}"
}

# ============================================================================
# EC2 COMPUTE INSTANCES
# ============================================================================

output "instance_ids" {
  description = "EC2 instance IDs"
  value       = aws_instance.app[*].id
}

output "instance_private_ips" {
  description = "Private IP addresses of EC2 instances"
  value       = aws_instance.app[*].private_ip
}

output "instance_count" {
  description = "Number of EC2 instances deployed"
  value       = local.instance_count
}

output "security_group_id" {
  description = "EC2 security group ID"
  value       = aws_security_group.compute.id
}

# Connect to instances via SSM Session Manager (no SSH key needed)
output "ssm_connect_command" {
  description = "Example AWS CLI command to connect to instance via SSM"
  value       = "aws ssm start-session --target ${aws_instance.app[0].id} --region ${local.aws_region}"
}

# ============================================================================
# CLOUDWATCH MONITORING & LOGGING
# ============================================================================

output "app_log_group" {
  description = "CloudWatch Log Group for application logs"
  value       = aws_cloudwatch_log_group.app.name
}

output "rds_log_group" {
  description = "CloudWatch Log Group for RDS logs"
  value       = aws_cloudwatch_log_group.rds.name
}

output "system_log_group" {
  description = "CloudWatch Log Group for system logs"
  value       = aws_cloudwatch_log_group.system.name
}

output "docker_log_group" {
  description = "CloudWatch Log Group for Docker logs"
  value       = aws_cloudwatch_log_group.docker.name
}

output "cloudwatch_console_url" {
  description = "URL to CloudWatch Logs console"
  value       = "https://console.aws.amazon.com/cloudwatch/home?region=${local.aws_region}#logStream:"
}

# ============================================================================
# IMPORTANT NEXT STEPS
# ============================================================================

output "next_steps" {
  description = "Next steps after infrastructure deployment"
  value = <<-EOF

=== INFRASTRUCTURE DEPLOYMENT COMPLETE ===

Next Steps:

1. **Verify Connectivity**:
   - Test RDS connection: psql -h ${aws_db_instance.main.address} -U ${aws_db_instance.main.username} -d ${aws_db_instance.main.db_name}
   - Test S3 access: aws s3 ls ${aws_s3_bucket.test_artifacts.id}
   - SSH to instance: ${replace(output.ssm_connect_command.value, "output.", "")}

2. **Deploy Application**:
   - Modify terraform.tfvars to set db_master_password via TF_VAR_db_master_password
   - Update EC2 user data script with your application deployment steps
   - Re-run terraform apply with updated configuration

3. **Monitor Logs**:
   - CloudWatch App Logs: aws logs tail ${aws_cloudwatch_log_group.app.name} --follow
   - CloudWatch System Logs: aws logs tail ${aws_cloudwatch_log_group.system.name} --follow
   - CloudWatch Docker Logs: aws logs tail ${aws_cloudwatch_log_group.docker.name} --follow

4. **Cost Tracking**:
   - Verify infrastructure cost with: infracost breakdown --path iac/
   - Check AWS Cost Explorer for actual charges: https://console.aws.amazon.com/cost-management/

5. **Teardown When Done**:
   - Run: terraform destroy (when testing is complete)
   - Verify no orphaned resources remain in AWS Console

6. **Troubleshooting**:
   - RDS Failover: Reboot primary instance to test automatic failover to replica
   - EC2 Issues: Use Systems Manager Session Manager for troubleshooting
   - Logs: Check CloudWatch Logs for error details

More information: See iac/README.md for detailed documentation

EOF
}

# ============================================================================
# DEBUG: Environment Summary
# ============================================================================

output "environment_summary" {
  description = "Summary of deployed environment"
  value = {
    environment       = local.environment
    project           = local.project_name
    region            = local.aws_region
    availability_zone = local.availability_zone
    instance_count    = local.instance_count
    instance_type     = local.instance_type
    rds_instance_type = local.db_instance_type
    s3_bucket_name    = local.s3_bucket_name
    expiration_date   = local.expiration_date
  }
}
