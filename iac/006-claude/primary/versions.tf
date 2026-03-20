terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31.0"
    }
  }
}

# Module version constraints (pinned to specific versions for reproducibility)
# These are referenced in module blocks throughout the configuration
# terraform-aws-modules/vpc/aws = 5.x (multi-AZ VPC support)
# terraform-aws-modules/rds-aurora/aws = 7.x (Aurora Global Database)
# terraform-aws-modules/alb/aws = 9.x (Application Load Balancer)
# terraform-aws-modules/autoscaling/aws = 7.x (Auto Scaling Groups)
