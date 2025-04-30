resource "azurerm_network_security_group" "nsg" {
  name                = "project-security-group"
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
  
    security_rule {
        name                       = "allow-localhost"
        priority                   = 1000
        direction                  = "Inbound"
        access                    = "Allow"
        protocol                  = "Tcp"
        source_port_range         = "*"
        destination_port_range     = "80"
        source_address_prefix     = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "allow-ssh"
        priority                   = 1100
        direction                  = "Inbound"
        access                    = "Allow"
        protocol                  = "Tcp"
        source_port_range         = "*"
        destination_port_range     = "22"
        source_address_prefix     = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "allow-db"
        priority                   = 1200
        direction                  = "Inbound"
        access                    = "Allow"
        protocol                  = "Tcp"
        source_port_range         = "*"
        destination_port_range     = "5000"
        source_address_prefix     = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "allow-streamlit"
        priority                   = 1300
        direction                  = "Inbound"
        access                    = "Allow"
        protocol                  = "Tcp"
        source_port_range         = "*"
        destination_port_range     = "8501"
        source_address_prefix     = "*"
        destination_address_prefix = "*"
    }

    security_rule {
      name                       = "allow-chromadb"
      priority                   = 1400
      direction                  = "Inbound"
      access                    = "Allow"
      protocol                  = "Tcp"
      source_port_range         = "*"
      destination_port_range     = "8000"
      source_address_prefix     = "*"
      destination_address_prefix = "*"
    }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "projectVN"
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.project.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "myNIC"
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
