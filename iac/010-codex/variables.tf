variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/22"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = ["10.20.0.0/24", "10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = ["10.20.10.0/24", "10.20.11.0/24", "10.20.12.0/24"]
}

variable "pipeline_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "hardened_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "asg_desired_capacity" {
  type    = number
  default = 3
}

variable "asg_max_size" {
  type    = number
  default = 5
}

variable "asg_min_size" {
  type    = number
  default = 2
}

variable "backend_bucket" {
  type    = string
  default = "hardened-image-pipeline-terraform-state"
}

variable "artifact_bucket" {
  type    = string
  default = "hardened-image-builder-artifacts"
}

variable "pipeline_table" {
  type    = string
  default = "hardened-image-pipeline-metadata"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "environment" {
  type    = string
  default = "dev"
}
