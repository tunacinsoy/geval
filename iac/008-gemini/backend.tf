terraform {
  backend "gcs" {
    bucket = "your-gcs-bucket-for-tfstate" # This will be replaced by a variable
    prefix = "terraform/state"
  }
}
