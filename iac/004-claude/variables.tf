variable "aws_region" {
  description = "AWS region for infrastructure deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "instance_type" {
  description = "RDS instance type (db.t3.micro, db.t3.small, etc.)"
  type        = string
  default     = "db.t3.micro"
}

variable "storage_size" {
  description = "Allocated storage for RDS instance in GB"
  type        = number
  default     = 20
  validation {
    condition     = var.storage_size >= 20 && var.storage_size <= 100
    error_message = "Storage size must be between 20 and 100 GB."
  }
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment for high availability"
  type        = bool
  default     = false
}

variable "backup_retention_days" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7
  validation {
    condition     = var.backup_retention_days >= 1 && var.backup_retention_days <= 90
    error_message = "Backup retention must be between 1 and 90 days."
  }
}

variable "database_name" {
  description = "Name of the initial database"
  type        = string
  default     = "orders_db"
  sensitive   = false
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "postgres"
  sensitive   = true
}

variable "password_length" {
  description = "Length of generated database password"
  type        = number
  default     = 32
  validation {
    condition     = var.password_length >= 16 && var.password_length <= 128
    error_message = "Password length must be between 16 and 128 characters."
  }
}

variable "enable_monitoring" {
  description = "Enable Enhanced Monitoring for RDS instance"
  type        = bool
  default     = true
}

variable "rds_proxy_enabled" {
  description = "Enable RDS Proxy for connection pooling (production use)"
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "database_subnet_1_cidr" {
  description = "CIDR block for primary database subnet"
  type        = string
  default     = "10.0.10.0/24"
}

variable "database_subnet_2_cidr" {
  description = "CIDR block for secondary database subnet (Multi-AZ)"
  type        = string
  default     = "10.0.11.0/24"
}

variable "enable_enhanced_monitoring" {
  description = "Enable CloudWatch Enhanced Monitoring for RDS"
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  description = "RDS Enhanced Monitoring interval in seconds (60 or 0 to disable)"
  type        = number
  default     = 60
  validation {
    condition     = contains([0, 60], var.monitoring_interval)
    error_message = "Monitoring interval must be 0 (disabled) or 60 seconds."
  }
}

variable "enable_deletion_protection" {
  description = "Protect RDS instance from accidental deletion"
  type        = bool
  default     = false
}

variable "backup_window" {
  description = "Preferred backup window (UTC)"
  type        = string
  default     = "02:00-03:00"
}

variable "maintenance_window" {
  description = "Preferred maintenance window (UTC)"
  type        = string
  default     = "sun:03:00-sun:04:00"
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
