resource "azurerm_public_ip" "pip-bastion" {
  allocation_method   = "Static"
  location            = data.azurerm_resource_group.rafael.location
  name                = "bastion-pip"
  resource_group_name = data.azurerm_resource_group.rafael.name

  tags = {
    "LAB" = "NETWORK"
  }
}

resource "azurerm_bastion_host" "bastion-hub" {
  location            = data.azurerm_resource_group.rafael.location
  name                = "bastion-hub"
  resource_group_name = data.azurerm_resource_group.rafael.name

  ip_configuration {
    name                 = "Config-ip-bastion"
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
    public_ip_address_id = azurerm_public_ip.pip-bastion.id
  }
}