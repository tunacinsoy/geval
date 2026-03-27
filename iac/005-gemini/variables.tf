variable "domain_name" {
  description = "The custom domain name for the CloudFront distribution."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
