provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
    virtual_machine {
      graceful_shutdown = true
    }
  }

  skip_provider_registration = false
}
