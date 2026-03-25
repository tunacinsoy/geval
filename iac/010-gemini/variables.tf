variable "aws_region" {
  description = "The AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "The ID of the existing VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the build instance and ASG"
  type        = list(string)
}

variable "ansible_playbook_uri" {
  description = "The S3 URI pointing to the CIS Level 1 Ansible playbook"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type for the application"
  type        = string
  default     = "t3.medium"
}