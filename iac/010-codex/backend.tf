terraform {
  backend "s3" {
    bucket         = "hardened-image-pipeline-terraform-state"
    key            = "global/hardened-image-pipeline/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "hardened-image-pipeline-lock"
    encrypt        = true
  }
}
