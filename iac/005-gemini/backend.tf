terraform {
  backend "s3" {
    bucket     = "my-terraform-state-bucket-for-cdn"
    key        = "global-cdn/terraform.tfstate"
    region     = "us-east-1"
    lock_table = "my-terraform-state-lock-table"
    encrypt    = true
  }
}
