# Primary Region Configuration Variables

variable "aws_region" {
  description = "AWS region for primary infrastructure"
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "Environment name (primary, secondary, etc.)"
  type        = string
  default     = "primary"

  validation {
    condition     = contains(["primary", "secondary"], var.environment)
    error_message = "Environment must be 'primary' or 'secondary'."
  }
}

variable "project_name" {
  description = "Project name for resource naming and tagging"
  type        = string
  default     = "multi-region-dr"
}

# Network Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC (identical in both regions)"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (ALB tier)"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private application subnets"
  type        = list(string)
  default     = ["10.10.11.0/24", "10.10.12.0/24"]
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private database subnets"
  type        = list(string)
  default     = ["10.10.21.0/24", "10.10.22.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for the region"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

# Compute Configuration
variable "instance_type" {
  description = "EC2 instance type for application tier"
  type        = string
  default     = "t3.medium"
}

variable "asg_min_size" {
  description = "Minimum number of instances in Auto Scaling Group (primary=2, secondary=1)"
  type        = number
  default     = 2

  validation {
    condition     = var.asg_min_size >= 1 && var.asg_min_size <= 10
    error_message = "ASG minimum size must be between 1 and 10."
  }
}

variable "asg_max_size" {
  description = "Maximum number of instances in Auto Scaling Group"
  type        = number
  default     = 10

  validation {
    condition     = var.asg_max_size >= 2 && var.asg_max_size <= 50
    error_message = "ASG maximum size must be between 2 and 50."
  }
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in Auto Scaling Group"
  type        = number
  default     = 2

  validation {
    condition     = var.asg_desired_capacity >= 1 && var.asg_desired_capacity <= 10
    error_message = "ASG desired capacity must be between 1 and 10."
  }
}

# Scaling Trigger Configuration
variable "cpu_scale_out_threshold" {
  description = "CPU threshold (%) to trigger scale-out"
  type        = number
  default     = 70

  validation {
    condition     = var.cpu_scale_out_threshold > 0 && var.cpu_scale_out_threshold < 100
    error_message = "CPU threshold must be between 0 and 100."
  }
}

variable "cpu_scale_in_threshold" {
  description = "CPU threshold (%) to trigger scale-in"
  type        = number
  default     = 30

  validation {
    condition     = var.cpu_scale_in_threshold > 0 && var.cpu_scale_in_threshold < 100
    error_message = "CPU threshold must be between 0 and 100."
  }
}

variable "memory_scale_out_threshold" {
  description = "Memory threshold (%) to trigger scale-out"
  type        = number
  default     = 80

  validation {
    condition     = var.memory_scale_out_threshold > 0 && var.memory_scale_out_threshold < 100
    error_message = "Memory threshold must be between 0 and 100."
  }
}

# Database Configuration
variable "db_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "16.1"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.small"
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS (GB)"
  type        = number
  default     = 100

  validation {
    condition     = var.db_allocated_storage >= 20 && var.db_allocated_storage <= 500
    error_message = "Allocated storage must be between 20 and 500 GB."
  }
}

variable "db_backup_retention_days" {
  description = "Database backup retention period (days)"
  type        = number
  default     = 7

  validation {
    condition     = var.db_backup_retention_days >= 1 && var.db_backup_retention_days <= 35
    error_message = "Backup retention must be between 1 and 35 days."
  }
}

# ALB Configuration
variable "alb_enable_http2" {
  description = "Enable HTTP/2 for ALB"
  type        = bool
  default     = true
}

variable "alb_enable_cross_zone" {
  description = "Enable cross-zone load balancing"
  type        = bool
  default     = true
}

# Health Check Configuration
variable "health_check_path" {
  description = "Health check endpoint path"
  type        = string
  default     = "/health"
}

variable "health_check_interval" {
  description = "Health check interval (seconds)"
  type        = number
  default     = 30

  validation {
    condition     = var.health_check_interval >= 5 && var.health_check_interval <= 300
    error_message = "Health check interval must be between 5 and 300 seconds."
  }
}

variable "health_check_timeout" {
  description = "Health check timeout (seconds)"
  type        = number
  default     = 5

  validation {
    condition     = var.health_check_timeout >= 2 && var.health_check_timeout <= 120
    error_message = "Health check timeout must be between 2 and 120 seconds."
  }
}

variable "health_check_healthy_threshold" {
  description = "Healthy threshold count for health checks"
  type        = number
  default     = 2

  validation {
    condition     = var.health_check_healthy_threshold >= 2 && var.health_check_healthy_threshold <= 10
    error_message = "Healthy threshold must be between 2 and 10."
  }
}

variable "health_check_unhealthy_threshold" {
  description = "Unhealthy threshold count for health checks"
  type        = number
  default     = 2

  validation {
    condition     = var.health_check_unhealthy_threshold >= 2 && var.health_check_unhealthy_threshold <= 10
    error_message = "Unhealthy threshold must be between 2 and 10."
  }
}

# Tags
variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Project     = "multi-region-dr"
    ManagedBy   = "Terraform"
    CreatedDate = "2026-03-20"
  }
}
