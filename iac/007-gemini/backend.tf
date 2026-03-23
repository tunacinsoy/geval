terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstatesa007aksafw"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
