variable "aws_region" {
  description = "AWS region for infrastructure deployment (EU only for GDPR compliance)"
  type        = string
  default     = "eu-west-1"

  validation {
    condition     = contains(["eu-west-1", "eu-central-1", "eu-north-1"], var.aws_region)
    error_message = "Region must be an EU region: eu-west-1 (Ireland), eu-central-1 (Frankfurt), or eu-north-1 (Stockholm)."
  }
}

variable "aws_region_replica" {
  description = "AWS replica region for cross-region replication and disaster recovery"
  type        = string
  default     = "eu-central-1"

  validation {
    condition     = contains(["eu-west-1", "eu-central-1", "eu-north-1"], var.aws_region_replica)
    error_message = "Replica region must be an EU region: eu-west-1 (Ireland), eu-central-1 (Frankfurt), or eu-north-1 (Stockholm)."
  }
}

variable "environment" {
  description = "Environment name (prod or dev)"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["prod", "dev"], var.environment)
    error_message = "Environment must be either 'prod' or 'dev'."
  }
}

variable "bucket_name" {
  description = "Name of the S3 bucket for HR documents"
  type        = string
  default     = "org-hr-documents-prod"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be lowercase alphanumeric with hyphens, starting and ending with alphanumeric."
  }
}

variable "bucket_name_replica" {
  description = "Name of the replica S3 bucket in secondary region"
  type        = string
  default     = "org-hr-documents-replica"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name_replica))
    error_message = "Bucket name must be lowercase alphanumeric with hyphens, starting and ending with alphanumeric."
  }
}

variable "versioning_enabled" {
  description = "Enable S3 bucket versioning for accidental deletion recovery"
  type        = bool
  default     = true
}

variable "mfa_delete_enabled" {
  description = "Enable MFA delete protection (requires MFA token to permanently delete objects)"
  type        = bool
  default     = true
}

variable "cross_region_replication_enabled" {
  description = "Enable cross-region replication to replica region for disaster recovery"
  type        = bool
  default     = true
}

variable "enable_cloudtrail_logging" {
  description = "Enable CloudTrail API logging for audit trail and compliance"
  type        = bool
  default     = true
}

variable "kms_key_rotation_enabled" {
  description = "Enable automatic KMS key rotation (annual)"
  type        = bool
  default     = true
}

variable "lifecycle_transition_days" {
  description = "Number of days before transitioning objects to Intelligent-Tiering"
  type        = number
  default     = 90

  validation {
    condition     = var.lifecycle_transition_days > 0 && var.lifecycle_transition_days <= 365
    error_message = "Lifecycle transition days must be between 1 and 365."
  }
}

variable "lifecycle_expiration_years" {
  description = "Number of years before objects expire (per retention policy)"
  type        = number
  default     = 7

  validation {
    condition     = var.lifecycle_expiration_years > 0 && var.lifecycle_expiration_years <= 10
    error_message = "Lifecycle expiration years must be between 1 and 10."
  }
}

variable "backup_retention_days" {
  description = "Number of days to retain S3 versioned objects for backup/recovery"
  type        = number
  default     = 30

  validation {
    condition     = var.backup_retention_days > 0 && var.backup_retention_days <= 365
    error_message = "Backup retention days must be between 1 and 365."
  }
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default = {
    DataClassification = "Confidential"
    Department         = "HR"
    Project            = "HR-Document-Storage"
  }
}
