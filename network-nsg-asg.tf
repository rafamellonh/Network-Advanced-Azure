#NSG Web
resource "azurerm_network_security_group" "nsg-web" {
  location            = data.azurerm_resource_group.rafael.location
  name                = "nsg-web"
  resource_group_name = data.azurerm_resource_group.rafael.name

  tags = {
    "LAB" = "NETWORK"
  }
}

resource "azurerm_network_security_rule" "port-80" {
  access                                     = "Allow"
  direction                                  = "Inbound"
  name                                       = "port-80"
  network_security_group_name                = azurerm_network_security_group.nsg-web.name
  priority                                   = 300
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  source_address_prefix                      = "*"
  destination_port_range                     = "80"
  destination_application_security_group_ids = [azurerm_application_security_group.asg-web.id]
  resource_group_name                        = data.azurerm_resource_group.rafael.name


}

#NSG Hub
resource "azurerm_network_security_group" "nsg-hub" {
  location            = data.azurerm_resource_group.rafael.location
  name                = "nsg-hub"
  resource_group_name = data.azurerm_resource_group.rafael.name

  tags = {
    "LAB" = "NETWORK"
  }

}


#NSG DATA   
resource "azurerm_network_security_group" "nsg-data" {
  location            = data.azurerm_resource_group.rafael.location
  name                = "nsg-data"
  resource_group_name = data.azurerm_resource_group.rafael.name

  tags = {
    "LAB" = "NETWORK"
  }
}

resource "azurerm_network_security_rule" "port-3389" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "port-3389"
  network_security_group_name = azurerm_network_security_group.nsg-data.name
  priority                    = 300
  protocol                    = "Tcp"
  resource_group_name         = data.azurerm_resource_group.rafael.name
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_port_range      = "3389"
  destination_address_prefix  = "*"


}

# ASG
resource "azurerm_application_security_group" "asg-web" {
  location            = data.azurerm_resource_group.rafael.location
  name                = "asg-web"
  resource_group_name = data.azurerm_resource_group.rafael.name

  tags = {
    "LAB" = "NETWORK"
  }
}