resource "azurerm_storage_account" "stomello001" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = data.azurerm_resource_group.rafael.location
  name                     = "stomello001"
  resource_group_name      = data.azurerm_resource_group.rafael.name

  tags = {
    "LAB" = "NETWORK"
  }

}

resource "azurerm_storage_share" "fileshare" {
  name               = "fileshare"
  quota              = 50
  storage_account_id = azurerm_storage_account.stomello001.id
}

resource "azurerm_private_endpoint" "pvt-endpoint" {
  location            = data.azurerm_resource_group.rafael.location
  name                = "pvt-endpoint"
  resource_group_name = data.azurerm_resource_group.rafael.name
  subnet_id           = azurerm_subnet.sub-datasrv.id

  private_service_connection {
    is_manual_connection           = false
    name                           = "psc-fileshare"
    private_connection_resource_id = azurerm_storage_account.stomello001.id
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.private-dns.id]
  }

}

resource "azurerm_private_dns_zone" "private-dns" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = data.azurerm_resource_group.rafael.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns-link" {
  name                  = "dns-link"
  private_dns_zone_name = azurerm_private_dns_zone.private-dns.name
  resource_group_name   = data.azurerm_resource_group.rafael.name
  virtual_network_id    = azurerm_virtual_network.vnetspoke02.id
}


resource "azurerm_private_dns_a_record" "dns_record" {
  name                = "dns_record"
  records             = [azurerm_private_endpoint.pvt-endpoint.private_service_connection[0].private_ip_address]
  resource_group_name = data.azurerm_resource_group.rafael.name
  ttl                 = 300
  zone_name           = azurerm_private_dns_zone.private-dns.name

}


/*
resource "azurerm_storage_account_network_rules" "sto-rules" {
  storage_account_id         = azurerm_storage_account.stomello001.id
  default_action             = "Deny"
  bypass                     = []
  ip_rules                   = []
  virtual_network_subnet_ids = [azurerm_subnet.sub-datasrv.id]
}
*/