provider "azurerm" {
  features {
  }
  subscription_id = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  client_id       = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  client_secret   = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  tenant_id       = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

  resource_provider_registrations = "none"
}


# Usar RG Existente

data "azurerm_resource_group" "rafael" {
  name = "rafael"
}