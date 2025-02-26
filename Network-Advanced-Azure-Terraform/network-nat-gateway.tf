resource "azurerm_public_ip" "pip-snat" {
  allocation_method   = "Static"
  location            = data.azurerm_resource_group.rafael.location
  name                = "pip-snat"
  resource_group_name = data.azurerm_resource_group.rafael.name
  sku                 = "Standard"

  tags = {
    "LAB" = "NETWORK"
  }
}

resource "azurerm_nat_gateway_public_ip_association" "nat-gateway-pip" {
  nat_gateway_id       = azurerm_nat_gateway.snat-vnet-spoke01.id
  public_ip_address_id = azurerm_public_ip.pip-snat.id
}

resource "azurerm_nat_gateway" "snat-vnet-spoke01" {
  location                = data.azurerm_resource_group.rafael.location
  name                    = "snat-vnet-spoke01"
  resource_group_name     = data.azurerm_resource_group.rafael.name
  idle_timeout_in_minutes = 4
  #zones = [ "1" ]

  tags = {
    "LAB" = "NETWORK"
  }

}

resource "azurerm_subnet_nat_gateway_association" "snat-vnet-assoc-spoke01" {
  nat_gateway_id = azurerm_nat_gateway.snat-vnet-spoke01.id
  subnet_id      = azurerm_subnet.sub-websrv.id
}