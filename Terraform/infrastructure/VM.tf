provider "azurerm" {
  features {}
  subscription_id = "b0d1dce5-b53b-4eb7-ac60-31d1b8ea9051" # your Azure subscription ID
}

# Create a resource group
resource "azurerm_resource_group" "project" {
  name     = "project-terraform"
  location = "West Europe"
}

resource "azurerm_public_ip" "public_ip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
  allocation_method   = "Static"
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "projectVM"
  resource_group_name   = azurerm_resource_group.project.name
  location              = azurerm_resource_group.project.location
  size                  = "Standard_D2ads_v6"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic.id]

  # Use only your public key here
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("ssh-keys/terraform-azure.pub")
  }


  disable_password_authentication = true

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
  publisher = "Canonical"
  offer     = "ubuntu-24_04-lts"
  sku       = "server"  
  version   = "latest"
 }
}
