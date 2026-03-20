terraform {
  required_version = ">= 1.14.7, < 1.15.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.62.0, < 4.63.0"
    }
  }
}
