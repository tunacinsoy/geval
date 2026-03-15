terraform {
  backend "s3" {
    # These values will be provided during the init command
    # bucket         = "my-flower-shop-tfstate-bucket"
    # key            = "prod/terraform.tfstate"
    # region         = "us-east-1"
    # dynamodb_table = "my-flower-shop-tfstate-lock"
    # encrypt        = true
  }
}
