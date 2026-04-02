variable "environment" {
  description = "Environment name (production, staging, development)"
  type        = string
  default     = "production"

  validation {
    condition     = contains(["production", "staging", "development"], var.environment)
    error_message = "Environment must be production, staging, or development."
  }
}

variable "domain_name" {
  description = "Custom domain name for CloudFront distribution (e.g., blog.example.com)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?(\\.[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?)*$", var.domain_name))
    error_message = "Domain name must be a valid DNS name."
  }
}

variable "origin_domain" {
  description = "Origin server domain name for images (e.g., images.example.com)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?(\\.[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?)*$", var.origin_domain))
    error_message = "Origin domain must be a valid DNS name."
  }
}

variable "origin_verify_token" {
  description = "Secret token for origin security header (X-Origin-Verify). Prevents direct access to origin."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.origin_verify_token) >= 16
    error_message = "Origin verify token must be at least 16 characters for security."
  }
}

variable "alert_email" {
  description = "Email address for CloudWatch alert notifications via SNS"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.alert_email))
    error_message = "Alert email must be a valid email address."
  }
}

# Cache TTL values (in seconds)
variable "evergreen_ttl" {
  description = "Time-to-live for evergreen images (not frequently updated). Default: 30 days"
  type        = number
  default     = 2592000 # 30 days

  validation {
    condition     = var.evergreen_ttl >= 0 && var.evergreen_ttl <= 31536000
    error_message = "TTL must be between 0 and 31536000 seconds (1 year)."
  }
}

variable "blog_post_ttl" {
  description = "Time-to-live for blog post images (updated occasionally). Default: 7 days"
  type        = number
  default     = 604800 # 7 days

  validation {
    condition     = var.blog_post_ttl >= 0 && var.blog_post_ttl <= 31536000
    error_message = "TTL must be between 0 and 31536000 seconds (1 year)."
  }
}

variable "featured_ttl" {
  description = "Time-to-live for featured images (frequently changed). Default: 1 day"
  type        = number
  default     = 86400 # 1 day

  validation {
    condition     = var.featured_ttl >= 0 && var.featured_ttl <= 31536000
    error_message = "TTL must be between 0 and 31536000 seconds (1 year)."
  }
}

# Alert thresholds
variable "cache_hit_alert_threshold" {
  description = "Cache hit ratio threshold (percentage) below which alert fires. Default: 75%"
  type        = number
  default     = 75

  validation {
    condition     = var.cache_hit_alert_threshold > 0 && var.cache_hit_alert_threshold < 100
    error_message = "Cache hit threshold must be between 0 and 100 percent."
  }
}

variable "latency_alert_threshold" {
  description = "95th percentile latency threshold (milliseconds) above which alert fires. Default: 750ms"
  type        = number
  default     = 750

  validation {
    condition     = var.latency_alert_threshold > 0 && var.latency_alert_threshold < 10000
    error_message = "Latency threshold must be between 0 and 10000 milliseconds."
  }
}

variable "enable_logging" {
  description = "Enable CloudFront access logging to S3"
  type        = bool
  default     = true
}

variable "enable_compression" {
  description = "Enable CloudFront compression (gzip, brotli) for images"
  type        = bool
  default     = true
}

variable "health_check_path" {
  description = "Origin health check path. Default: /health or /images/"
  type        = string
  default     = "/health"
}

variable "health_check_interval" {
  description = "Origin health check interval in seconds"
  type        = number
  default     = 30

  validation {
    condition     = contains([10, 30], var.health_check_interval)
    error_message = "Health check interval must be 10 or 30 seconds."
  }
}

variable "health_check_failure_count" {
  description = "Number of consecutive health check failures before marking origin unhealthy"
  type        = number
  default     = 3

  validation {
    condition     = var.health_check_failure_count >= 1 && var.health_check_failure_count <= 5
    error_message = "Health check failure count must be between 1 and 5."
  }
}
