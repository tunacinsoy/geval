variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Primary AWS region for the hardened image pipeline"
}

variable "aws_profile" {
  type        = string
  default     = "default"
  description = "AWS CLI profile for authenticated operations"
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile
}
