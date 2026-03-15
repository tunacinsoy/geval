variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  default     = "secure-hr-documents-storage"
}

variable "iam_group_name" {
  description = "The name of the IAM group for HR personnel."
  type        = string
  default     = "hr-document-access"
}
