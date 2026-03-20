terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-for-multi-region-dr"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-lock-for-multi-region-dr"
    encrypt        = true
  }
}
