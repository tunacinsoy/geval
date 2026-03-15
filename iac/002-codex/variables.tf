variable "region" {
  description = "Primary AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "replication_region" {
  description = "Secondary region for bucket replication"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Deployment environment identifier"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner identifier for tagging"
  type        = string
  default     = "hr-operations"
}

variable "vpc_cidr" {
  description = "CIDR block for the private VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "private_zone_name" {
  description = "Internal domain for the HR portal"
  type        = string
  default     = "hr.internal"
}

variable "acm_certificate_arn" {
  description = "ARN of the TLS certificate used by the ALB"
  type        = string
  default     = ""
}

variable "desired_task_count" {
  description = "Desired ECS task count"
  type        = number
  default     = 2
}

variable "min_task_count" {
  description = "Minimum ECS tasks for auto-scaling"
  type        = number
  default     = 1
}

variable "max_task_count" {
  description = "Maximum ECS tasks for auto-scaling"
  type        = number
  default     = 3
}

variable "latency_threshold_seconds" {
  description = "Target response latency threshold"
  type        = number
  default     = 2
}
