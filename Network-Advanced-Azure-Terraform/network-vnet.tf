
# VNET Hub
resource "azurerm_virtual_network" "vnet-hub" {
  address_space       = ["192.168.0.0/16"]
  location            = data.azurerm_resource_group.rafael.location
  name                = "vnet-hub"
  resource_group_name = data.azurerm_resource_group.rafael.name

  tags = {
    "LAB" = "NETWORK"
  }
}

# Subnet Srv
resource "azurerm_subnet" "sub-srv" {
  address_prefixes     = ["192.168.1.0/24"]
  name                 = "sub-srv"
  resource_group_name  = data.azurerm_resource_group.rafael.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name

}

resource "azurerm_subnet_network_security_group_association" "sub-srv-nsg" {
  network_security_group_id = azurerm_network_security_group.nsg-hub.id
  subnet_id                 = azurerm_subnet.sub-srv.id

}


# Subnet azure bastion
resource "azurerm_subnet" "AzureBastionSubnet" {
  address_prefixes     = ["192.168.250.0/24"]
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.rafael.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
}

# VNET Spoke 01
resource "azurerm_virtual_network" "vnet-spoke01" {
  address_space       = ["10.10.0.0/16"]
  location            = data.azurerm_resource_group.rafael.location
  name                = "vnet-spoke01"
  resource_group_name = data.azurerm_resource_group.rafael.name

  tags = {
    "LAB" = "NETWORK"
  }
}

#subnet web srv
resource "azurerm_subnet" "sub-websrv" {
  address_prefixes     = ["10.10.1.0/24"]
  name                 = "sub-websrv"
  resource_group_name  = data.azurerm_resource_group.rafael.name
  virtual_network_name = azurerm_virtual_network.vnet-spoke01.name
}


resource "azurerm_subnet_network_security_group_association" "sub-websrv-nsg" {
  network_security_group_id = azurerm_network_security_group.nsg-web.id
  subnet_id                 = azurerm_subnet.sub-websrv.id
}


# VNET Spoke 02
resource "azurerm_virtual_network" "vnetspoke02" {
  address_space       = ["172.16.0.0/16"]
  location            = data.azurerm_resource_group.rafael.location
  name                = "vnet-spoke02"
  resource_group_name = data.azurerm_resource_group.rafael.name


  tags = {
    "LAB" = "NETWORK"
  }
}

# subnet srv data
resource "azurerm_subnet" "sub-datasrv" {
  address_prefixes     = ["172.16.1.0/24"]
  name                 = "sub-datasrv"
  resource_group_name  = data.azurerm_resource_group.rafael.name
  virtual_network_name = azurerm_virtual_network.vnetspoke02.name

  service_endpoints = ["Microsoft.Storage"] # Adicione esta linha



}

resource "azurerm_subnet_network_security_group_association" "sub-datasrv-nsg" {
  network_security_group_id = azurerm_network_security_group.nsg-data.id
  subnet_id                 = azurerm_subnet.sub-datasrv.id

}