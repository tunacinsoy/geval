# Secondary Region Configuration Values (Disaster Recovery Standby)

aws_region  = "eu-west-1"
environment = "secondary"
project_name = "multi-region-dr"

# Network Configuration (IDENTICAL to primary for seamless failover)
vpc_cidr = "10.10.0.0/16"

public_subnet_cidrs = [
  "10.10.1.0/24",  # eu-west-1a
  "10.10.2.0/24"   # eu-west-1b
]

private_app_subnet_cidrs = [
  "10.10.11.0/24", # eu-west-1a
  "10.10.12.0/24"  # eu-west-1b
]

private_db_subnet_cidrs = [
  "10.10.21.0/24", # eu-west-1a
  "10.10.22.0/24"  # eu-west-1b
]

availability_zones = ["eu-west-1a", "eu-west-1b"]

# Compute Configuration
instance_type = "t3.medium"

# Auto Scaling Group - Secondary region: min 1 (cost optimization), max 10 (scales on failover)
asg_min_size          = 1
asg_max_size          = 10
asg_desired_capacity  = 1

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
  Environment = "secondary"
  ManagedBy   = "Terraform"
  CreatedDate = "2026-03-20"
  Region      = "eu-west-1"
}
