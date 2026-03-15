# Test Environment Configuration
# Temporary playground for 2-3 week feature validation

# AWS Region
aws_region = "us-east-1"

# VPC Configuration
vpc_cidr_block = "10.0.0.0/16"

# Compute Configuration
instance_count = 2                # Team can adjust from 1-5
instance_type  = "t3.micro"       # Minimal cost, suitable for testing

# RDS Configuration
rds_instance_class   = "db.t3.micro"     # Minimal cost for testing
db_allocated_storage = 20                 # GB, adjustable for larger test datasets
db_master_username   = "testadmin"       # Default username (change in actual deployment)

# Environment Metadata
environment  = "test"
project_name = "feature-testing"

# Optional: Uncomment to enable ALB (additional cost)
# enable_alb = true

# Optional: Uncomment to enable automatic shutdown
# enable_autoshutdown = true
# autoshutdown_time   = "22:00"  # 10 PM local time
