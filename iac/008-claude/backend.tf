terraform {
  backend "gcs" {
    bucket = "terraform-state-008-pubsub-order-processing"
    prefix = "terraform/state"
  }
}
