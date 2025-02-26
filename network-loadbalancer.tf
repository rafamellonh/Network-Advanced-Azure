resource "azurerm_public_ip" "pip-front-lb" {
  allocation_method   = "Static"
  location            = data.azurerm_resource_group.rafael.location
  name                = "pip-front-lb"
  resource_group_name = data.azurerm_resource_group.rafael.name

  tags = {
    "LAB" = "NETWORK"
  }

}

resource "azurerm_lb" "lb-web01" {
  location            = data.azurerm_resource_group.rafael.location
  name                = "lb-web01"
  resource_group_name = data.azurerm_resource_group.rafael.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress-front-lb"
    public_ip_address_id = azurerm_public_ip.pip-front-lb.id
  }

  tags = {
    "LAB" = "NETWORK"
  }
}


resource "azurerm_lb_backend_address_pool" "backend-pool-lb-web01" {
  loadbalancer_id = azurerm_lb.lb-web01.id
  name            = "backend-pool-lb-web01"

}

resource "azurerm_network_interface_backend_address_pool_association" "nic-backend-vm-web01" {
  ip_configuration_name   = "ipconfig-vm-web01"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend-pool-lb-web01.id
  network_interface_id    = azurerm_network_interface.nic-vm-web01.id
}

resource "azurerm_network_interface_backend_address_pool_association" "nic-backend-vm-web02" {
  ip_configuration_name   = "ipconfig-vm-web02"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend-pool-lb-web01.id
  network_interface_id    = azurerm_network_interface.nic-vm-web02.id
}

resource "azurerm_lb_probe" "probe-web01" {
  loadbalancer_id = azurerm_lb.lb-web01.id
  name            = "probe-web01"
  port            = 80
  protocol        = "Tcp"
}

resource "azurerm_lb_rule" "rule-port80" {
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress-front-lb"
  frontend_port                  = 80
  loadbalancer_id                = azurerm_lb.lb-web01.id
  name                           = "rule-port80"
  protocol                       = "Tcp"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend-pool-lb-web01.id]
  probe_id                       = azurerm_lb_probe.probe-web01.id

  disable_outbound_snat = true
}

