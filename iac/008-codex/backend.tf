terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "example-org"

    workspaces {
      prefix = "order-event-messaging-"
    }
  }
}
