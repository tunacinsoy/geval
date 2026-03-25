variable "blog_domain" {
  type    = string
  default = "blog.example.com"
}

variable "origin_bucket_name" {
  type    = string
  default = "global-image-assets-primary"
}

variable "failover_bucket_name" {
  type    = string
  default = "global-image-assets-failover"
}

variable "logging_bucket_name" {
  type    = string
  default = "global-image-delivery-logs"
}

variable "cache_ttl_seconds" {
  type    = number
  default = 1800
}

variable "invalidations_per_day" {
  type    = number
  default = 10
}

variable "authoring_vpc_id" {
  type    = string
  default = ""
}

variable "authoring_role_name" {
  type    = string
  default = "image-authoring-role"
}

variable "zone_comment" {
  type    = string
  default = "Global blog delivery zone"
}

variable "edge_price_class" {
  type        = string
  description = "Price class limits CloudFront edge locations"
  default     = "PriceClass_All"
}

variable "max_requests_per_second" {
  type    = number
  default = 1000
}
variable "authoring_route_table_ids" {
  type    = list(string)
  default = []
}
