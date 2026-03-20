# Primary Region Configuration Values

aws_region  = "eu-central-1"
environment = "primary"
project_name = "multi-region-dr"

# Network Configuration
vpc_cidr = "10.10.0.0/16"

public_subnet_cidrs = [
  "10.10.1.0/24",  # eu-central-1a
  "10.10.2.0/24"   # eu-central-1b
]

private_app_subnet_cidrs = [
  "10.10.11.0/24", # eu-central-1a
  "10.10.12.0/24"  # eu-central-1b
]

private_db_subnet_cidrs = [
  "10.10.21.0/24", # eu-central-1a
  "10.10.22.0/24"  # eu-central-1b
]

availability_zones = ["eu-central-1a", "eu-central-1b"]

# Compute Configuration
instance_type = "t3.medium"

# Auto Scaling Group - Primary region: min 2, max 10
asg_min_size          = 2
asg_max_size          = 10
asg_desired_capacity  = 2

# Scaling Triggers
cpu_scale_out_threshold      = 70
cpu_scale_in_threshold       = 30
memory_scale_out_threshold   = 80

# Database Configuration
db_engine_version         = "16.1"
db_instance_class         = "db.t3.small"
db_allocated_storage      = 100
db_backup_retention_days  = 7

# ALB Configuration
alb_enable_http2      = true
alb_enable_cross_zone = true

# Health Check Configuration
health_check_path                    = "/health"
health_check_interval                = 30
health_check_timeout                 = 5
health_check_healthy_threshold       = 2
health_check_unhealthy_threshold     = 2

# Common Tags
common_tags = {
  Project     = "multi-region-dr"
  Environment = "primary"
  ManagedBy   = "Terraform"
  CreatedDate = "2026-03-20"
  Region      = "eu-central-1"
}
