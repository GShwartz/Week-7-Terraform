# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = "Virtual_Network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = var.node_address_space
}

#creating subnet for VMSS (app)
resource "azurerm_subnet" "vmss-subnet" {
  name                 = "WebApp"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.node_address_prefix

}

#creating NSG for VMSS(app) wan and lan
resource "azurerm_network_security_group" "VMSS_nsg" {
  name                = "NSG-WebApp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Web"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }
  security_rule {
    name                         = "SSH"
    priority                     = 200
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "22"
    source_address_prefix        = "*"
    destination_address_prefixes = var.node_address_prefix
  }
}

#assosiating NSG to VMSS(app) subnet
resource "azurerm_subnet_network_security_group_association" "VMSS_association" {
  subnet_id                 = azurerm_subnet.vmss-subnet.id
  network_security_group_id = azurerm_network_security_group.VMSS_nsg.id

}
