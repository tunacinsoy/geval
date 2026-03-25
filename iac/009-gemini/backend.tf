terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-placeholder"
    key            = "hybrid-dns/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-terraform-state-lock-table-placeholder"
    encrypt        = true
  }
}
