variable "domain_name" {
  description = "The custom domain name for the website."
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default = {
    Project     = "FlowerShopWebsite"
    Environment = "Production"
  }
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate for the custom domain."
  type        = string
}
