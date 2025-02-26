resource "azurerm_virtual_network_peering" "vnetHub-to-vnetSpoke01" {
  name                      = "vnetHub-to-vnetSpoke01"
  remote_virtual_network_id = azurerm_virtual_network.vnet-spoke01.id
  resource_group_name       = data.azurerm_resource_group.rafael.name
  virtual_network_name      = azurerm_virtual_network.vnet-hub.name
}

resource "azurerm_virtual_network_peering" "vnetSpo01-to-vnetHub" {
  name                      = "vnetSpo01-to-vnetHub"
  remote_virtual_network_id = azurerm_virtual_network.vnet-hub.id
  resource_group_name       = data.azurerm_resource_group.rafael.name
  virtual_network_name      = azurerm_virtual_network.vnet-spoke01.name
}


resource "azurerm_virtual_network_peering" "vnetHub-to-vnetSpo02" {
  name                      = "vnetHub-to-vnetSpo02"
  remote_virtual_network_id = azurerm_virtual_network.vnetspoke02.id
  resource_group_name       = data.azurerm_resource_group.rafael.name
  virtual_network_name      = azurerm_virtual_network.vnet-hub.name
}


resource "azurerm_virtual_network_peering" "vnetSpo02-to-vnetHub" {
  name                      = "vnetSpo02-to-vnetHub"
  remote_virtual_network_id = azurerm_virtual_network.vnet-hub.id
  resource_group_name       = data.azurerm_resource_group.rafael.name
  virtual_network_name      = azurerm_virtual_network.vnetspoke02.name
}