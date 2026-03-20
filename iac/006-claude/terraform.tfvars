# Multi-Region Disaster Recovery Infrastructure Configuration
# Primary: eu-central-1, Secondary: eu-west-1

primary_region   = "eu-central-1"
secondary_region = "eu-west-1"

project_name = "multi-region-dr"

# Network Configuration
vpc_cidr                    = "10.10.0.0/16"
public_subnet_cidrs         = ["10.10.1.0/24", "10.10.2.0/24"]
private_app_subnet_cidrs    = ["10.10.11.0/24", "10.10.12.0/24"]
private_db_subnet_cidrs     = ["10.10.21.0/24", "10.10.22.0/24"]
primary_availability_zones  = ["eu-central-1a", "eu-central-1b"]
secondary_availability_zones = ["eu-west-1a", "eu-west-1b"]

# Compute Configuration
instance_type        = "t3.medium"
asg_min_size         = 2
asg_max_size         = 10
asg_desired_capacity = 2

# Database Configuration
db_engine_version         = "16.1"
db_instance_class         = "db.t3.small"
db_allocated_storage      = 100
db_backup_retention_days  = 7

# Health Check Configuration
health_check_path                = "/health"
health_check_interval            = 30
health_check_timeout             = 5
health_check_healthy_threshold   = 2
health_check_unhealthy_threshold = 2

# Tags
common_tags = {
  Project     = "multi-region-dr"
  ManagedBy   = "Terraform"
  CreatedDate = "2026-03-20"
}
