terraform {
  backend "s3" {
    bucket         = "global-image-delivery-terraform-state"
    key            = "001-accelerate-cdn/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "global-image-delivery-terraform-lock"
    encrypt        = true
    acl            = "bucket-owner-full-control"
  }
}
