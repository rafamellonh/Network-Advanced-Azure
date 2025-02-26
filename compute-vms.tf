#VM Web01
resource "azurerm_network_interface" "nic-vm-web01" {
  location            = data.azurerm_resource_group.rafael.location
  name                = "nic-vm-web01"
  resource_group_name = data.azurerm_resource_group.rafael.name
  ip_configuration {
    name                          = "ipconfig-vm-web01"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.sub-websrv.id
  }

  tags = {
    "LAB" = "NETWORK"
  }
}

# ASG VM Web01
resource "azurerm_network_interface_application_security_group_association" "asg-nic-vm-web01" {
  application_security_group_id = azurerm_application_security_group.asg-web.id
  network_interface_id          = azurerm_network_interface.nic-vm-web01.id

}

resource "azurerm_windows_virtual_machine" "vm-web01" {
  admin_password        = "@#xxxxxxxxxxxxxxxx@#"
  admin_username        = "rafael.admin"
  location              = data.azurerm_resource_group.rafael.location
  name                  = "vm-web01"
  network_interface_ids = [azurerm_network_interface.nic-vm-web01.id]
  resource_group_name   = data.azurerm_resource_group.rafael.name
  size                  = "Standard_B2s"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  tags = {
    "LAB" = "NETWORK"
  }
}

#ASG VM Web02
resource "azurerm_network_interface_application_security_group_association" "asg-nic-vm-web02" {
  application_security_group_id = azurerm_application_security_group.asg-web.id
  network_interface_id          = azurerm_network_interface.nic-vm-web02.id

}

# Script setup IIS
resource "azurerm_virtual_machine_extension" "vm_extension-web01" {
  name                 = "CustomScriptExtension"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm-web01.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
{
  "commandToExecute": "powershell -ExecutionPolicy Unrestricted -Command \"Add-WindowsFeature Web-Server -IncludeManagementTools; Remove-Item C:\\inetpub\\wwwroot\\iisstart.htm -Force; Add-Content -Path C:\\inetpub\\wwwroot\\Default.htm -Value 'TFTEC AZ-700 - $env:computername'\""
}
SETTINGS

  tags = {
    "LAB" = "NETWORK"
  }
}


#VM Web02
resource "azurerm_network_interface" "nic-vm-web02" {
  location            = data.azurerm_resource_group.rafael.location
  name                = "nic-vm-web02"
  resource_group_name = data.azurerm_resource_group.rafael.name
  ip_configuration {
    name                          = "ipconfig-vm-web02"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.sub-websrv.id
  }

  tags = {
    "LAB" = "NETWORK"
  }
}

resource "azurerm_windows_virtual_machine" "vm-web02" {
  admin_password        = "@#xxxxxxxxxxxxxxxx@#"
  admin_username        = "rafael.admin"
  location              = data.azurerm_resource_group.rafael.location
  name                  = "vm-web02"
  network_interface_ids = [azurerm_network_interface.nic-vm-web02.id]
  resource_group_name   = data.azurerm_resource_group.rafael.name
  size                  = "Standard_B2s"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  tags = {
    "LAB" = "NETWORK"
  }
}

# Script setup IIS
resource "azurerm_virtual_machine_extension" "vm_extension-web02" {
  name                 = "CustomScriptExtension"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm-web02.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
{
"commandToExecute": "powershell -ExecutionPolicy Unrestricted -Command \"Add-WindowsFeature Web-Server -IncludeManagementTools; Remove-Item C:\\inetpub\\wwwroot\\iisstart.htm -Force; Add-Content -Path C:\\inetpub\\wwwroot\\Default.htm -Value 'TFTEC AZ-700 - $env:computername'\""
}
SETTINGS

  tags = {
    "LAB" = "NETWORK"
  }
}

# VM ADDS

resource "azurerm_network_interface" "nic-vm-adds" {
  location            = data.azurerm_resource_group.rafael.location
  name                = "nic-vm-adds"
  resource_group_name = data.azurerm_resource_group.rafael.name
  ip_configuration {
    name                          = "ipconfig-vm-adds"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.sub-srv.id
  }

  tags = {
    "LAB" = "NETWORK"
  }
}

resource "azurerm_windows_virtual_machine" "vm-adds" {
  admin_password        = "@#xxxxxxxxxxxxxxxx@#"
  admin_username        = "rafael.admin"
  location              = data.azurerm_resource_group.rafael.location
  name                  = "vm-adds"
  network_interface_ids = [azurerm_network_interface.nic-vm-adds.id]
  resource_group_name   = data.azurerm_resource_group.rafael.name
  size                  = "Standard_B2s"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  tags = {
    "LAB" = "NETWORK"
  }

}

# VM data


resource "azurerm_network_interface" "nic-vm-data" {
  location            = data.azurerm_resource_group.rafael.location
  name                = "nic-vm-data"
  resource_group_name = data.azurerm_resource_group.rafael.name
  ip_configuration {
    name                          = "ipconfig-vm-data"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.sub-datasrv.id
    public_ip_address_id          = azurerm_public_ip.pip-nic-vm-data.id

  }

  tags = {
    "LAB" = "NETWORK"
  }
}

resource "azurerm_public_ip" "pip-nic-vm-data" {
  allocation_method   = "Static"
  location            = data.azurerm_resource_group.rafael.location
  name                = "pip-nic-vm-data"
  resource_group_name = data.azurerm_resource_group.rafael.name

  tags = {
    "LAB" = "NETWORK"
  }
}


resource "azurerm_windows_virtual_machine" "vm-data01" {
  admin_password        = "@#xxxxxxxxxxxxxxxx@#"
  admin_username        = "rafael.admin"
  location              = data.azurerm_resource_group.rafael.location
  name                  = "vm-data01"
  network_interface_ids = [azurerm_network_interface.nic-vm-data.id]
  resource_group_name   = data.azurerm_resource_group.rafael.name
  size                  = "Standard_B2s"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  tags = {
    "LAB" = "NETWORK"
  }

}
