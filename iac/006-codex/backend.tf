terraform {
  backend "s3" {
    bucket         = "terraform-state-prod"
    key            = "${var.environment}/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
    kms_key_id     = "alias/terraform-state-key"
    acl            = "bucket-owner-full-control"
  }
}
