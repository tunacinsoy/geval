variable "aws_region" {
  description = "AWS region for most resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Optional AWS CLI profile name for local development"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Logical environment name used in names and state keys"
  type        = string
  default     = "prod"
}

variable "primary_domain" {
  description = "Primary domain that visitors will request"
  type        = string
  default     = "flower-shop.example.com"
}

variable "www_domain" {
  description = "WWW alias for the primary domain"
  type        = string
  default     = "www.flower-shop.example.com"
}

variable "route53_zone_id" {
  description = "Route 53 hosted zone ID that manages the domain"
  type        = string
  default     = "Z0000000000000"
}

variable "deployment_email" {
  description = "Email address used for alert subscriptions and notifications"
  type        = string
  default     = "ops@example.com"
}

variable "cache_ttl_seconds" {
  description = "Default TTL applied to CloudFront cache behaviors"
  type        = number
  default     = 3600
}

variable "asset_bucket_suffix" {
  description = "Suffix for the asset bucket to keep names unique"
  type        = string
  default     = "static-assets"
}

variable "log_bucket_suffix" {
  description = "Suffix for the logging bucket"
  type        = string
  default     = "distribution-logs"
}
