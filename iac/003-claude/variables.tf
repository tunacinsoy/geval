# AWS Region
variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-east-1"
}

# VPC Configuration
variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Compute Configuration
variable "instance_count" {
  description = "Number of EC2 instances to launch (1-5)"
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 5
    error_message = "instance_count must be between 1 and 5"
  }
}

variable "instance_type" {
  description = "EC2 instance type (t3.micro for minimal cost)"
  type        = string
  default     = "t3.micro"
}

# RDS Configuration
variable "rds_instance_class" {
  description = "RDS instance class (db.t3.micro for testing)"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS database in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.db_allocated_storage >= 20 && var.db_allocated_storage <= 100
    error_message = "db_allocated_storage must be between 20 and 100 GB"
  }
}

variable "db_master_username" {
  description = "Master username for RDS database"
  type        = string
  default     = "testadmin"
  sensitive   = false  # Username is not sensitive, but avoid common values

  validation {
    condition     = length(var.db_master_username) >= 1 && length(var.db_master_username) <= 16
    error_message = "db_master_username must be between 1 and 16 characters"
  }
}

variable "db_master_password" {
  description = "Master password for RDS database (MUST be set via environment variable TF_VAR_db_master_password)"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_master_password) >= 8
    error_message = "db_master_password must be at least 8 characters long"
  }
}

# Environment Configuration
variable "environment" {
  description = "Environment name (test)"
  type        = string
  default     = "test"

  validation {
    condition     = contains(["test"], var.environment)
    error_message = "environment must be 'test' for this temporary playground"
  }
}

variable "project_name" {
  description = "Project name for resource naming and tagging"
  type        = string
  default     = "feature-testing"

  validation {
    condition     = length(var.project_name) >= 1 && length(var.project_name) <= 32
    error_message = "project_name must be between 1 and 32 characters"
  }
}

# Optional Configuration
variable "enable_alb" {
  description = "Enable Application Load Balancer for multi-instance distribution (optional, adds cost)"
  type        = bool
  default     = false
}

variable "enable_autoshutdown" {
  description = "Enable automatic shutdown during off-hours (optional, saves cost)"
  type        = bool
  default     = false
}

variable "autoshutdown_time" {
  description = "Time to shutdown instances in HH:MM format (if enable_autoshutdown = true)"
  type        = string
  default     = "22:00"
}
