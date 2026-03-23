# Environment & Project Configuration
variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "region" {
  description = "AWS region for infrastructure deployment"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming and tagging"
  type        = string
  default     = "ami-hardening"
}

variable "created_at" {
  description = "Timestamp when infrastructure was created"
  type        = string
  default     = "2026-03-23"
}

# VPC & Network Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (ALB tier)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (ASG instances)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for multi-AZ deployment"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# Compute Configuration
variable "image_builder_instance_type" {
  description = "EC2 instance type for Image Builder"
  type        = string
  default     = "t3.medium"
}

variable "asg_instance_type" {
  description = "EC2 instance type for Auto Scaling Group"
  type        = string
  default     = "t3.micro" # dev, overridden in staging/prod via tfvars
}

variable "asg_min_size" {
  description = "Minimum number of instances in Auto Scaling Group"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of instances in Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in Auto Scaling Group"
  type        = number
  default     = 1
}

# Image Builder Configuration
variable "build_schedule" {
  description = "Cron expression for scheduled image builds (nightly 2 AM UTC)"
  type        = string
  default     = "0 2 * * *"
}

variable "build_timeout_minutes" {
  description = "Maximum time for image build to complete (minutes)"
  type        = number
  default     = 30
}

variable "image_retention_days" {
  description = "Number of days to retain images before archiving"
  type        = number
  default     = 7 # dev, overridden in staging/prod
}

# Health Check & Instance Refresh Configuration
variable "health_check_interval_seconds" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout_seconds" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive successful health checks before instance marked healthy"
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive failed health checks before instance marked unhealthy"
  type        = number
  default     = 2
}

variable "connection_drain_timeout_seconds" {
  description = "Time to drain in-flight requests before instance termination"
  type        = number
  default     = 30
}

variable "canary_deployment_percentage" {
  description = "Percentage of instances to update in canary phase (0-100)"
  type        = number
  default     = 0 # dev, overridden to 15-20 in staging/prod
}

# Monitoring & Logging Configuration
variable "log_retention_days" {
  description = "CloudWatch Logs retention in days"
  type        = number
  default     = 7 # dev, overridden to 30+ in staging/prod
}

variable "enable_alb" {
  description = "Enable Application Load Balancer (false for dev cost optimization)"
  type        = bool
  default     = false
}

variable "cost_optimization_enabled" {
  description = "Enable cost optimization features (off-peak scaling, lifecycle policies)"
  type        = bool
  default     = true
}

variable "enable_compliance_scanning" {
  description = "Enable CIS Level 1 compliance scanning (disabled in dev, required in staging/prod)"
  type        = bool
  default     = false
}

# Tagging Configuration
variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Admin Access (for SSH bastion, if needed)
variable "admin_ssh_cidr" {
  description = "CIDR block for SSH access to image builder (restrict in production)"
  type        = string
  default     = "0.0.0.0/0" # Restrict this in production
  sensitive   = true
}
