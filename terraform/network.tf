resource "azurerm_virtual_network" "incident_vnet" {
  name                = "612-vnet-incident-api-${var.ENVIRONMENT}"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.incident_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "incident_subnet" {
  name                 = "612-subnet-incident-api-${var.ENVIRONMENT}"
  resource_group_name  = azurerm_resource_group.incident_rg.name
  virtual_network_name = azurerm_virtual_network.incident_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_network_interface" "incident_nic" {
  name                = "612-nic-incident-api-${var.ENVIRONMENT}"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.incident_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.incident_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Security Groups
resource "azurerm_network_security_group" "incident_sg" {
  name                = "612-sg-incident-api-${var.ENVIRONMENT}"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.incident_rg.name

  security_rule {
    name                       = "ssh-allow"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    destination_address_prefix = "*"
    source_address_prefix      = "*"
  }
  security_rule {
    name                       = "http-allow"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    destination_address_prefix = "*"
    source_address_prefix      = "*"
  }
  security_rule {
    name                       = "https-allow"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    destination_address_prefix = "*"
    source_address_prefix      = "*"
  }
  # PODRIA NO USARSE... SI PUSIERAMOS DNS
  security_rule {
    name                       = "api-allow"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    destination_address_prefix = "*"
    source_address_prefix      = "*"
  }
  security_rule {
    name                       = "vpn-allow"
    priority                   = 105
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "51820"
    destination_address_prefix = "*"
    source_address_prefix      = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "name" {
  subnet_id                 = azurerm_subnet.incident_subnet.id
  network_security_group_id = azurerm_network_security_group.incident_sg.id
}