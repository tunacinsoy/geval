# Infrastructure Variables for Flower Shop Website

variable "aws_region" {
  type        = string
  description = "AWS region for deployment"
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "AWS region must be a valid region code (e.g., us-east-1, eu-west-1)."
  }
}

variable "domain_name" {
  type        = string
  description = "Custom domain name for the website (e.g., example.com)"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9](\\.[a-z0-9][a-z0-9-]*[a-z0-9])*\\.[a-z]{2,}$", lower(var.domain_name)))
    error_message = "Domain name must be a valid domain (e.g., example.com, shop.example.com)."
  }
}

variable "environment_tag" {
  type        = string
  description = "Environment name for resource tagging"
  default     = "production"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment_tag)
    error_message = "Environment must be development, staging, or production."
  }
}

variable "cloudfront_cache_ttl" {
  type        = number
  description = "Default CloudFront cache TTL in seconds for HTML content"
  default     = 86400 # 24 hours

  validation {
    condition     = var.cloudfront_cache_ttl > 0 && var.cloudfront_cache_ttl <= 31536000
    error_message = "Cache TTL must be between 1 second and 1 year (31536000 seconds)."
  }
}

variable "s3_bucket_versioning_enabled" {
  type        = bool
  description = "Enable S3 bucket versioning for content rollback capability"
  default     = true
}

variable "enable_logging" {
  type        = bool
  description = "Enable CloudFront and S3 access logging"
  default     = true
}

variable "enable_monitoring" {
  type        = bool
  description = "Enable CloudWatch monitoring and alarms"
  default     = true
}
