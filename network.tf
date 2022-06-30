# Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  name                = "Weight_Tracker_Vnet"
  resource_group_name = azurerm_resource_group.staging_rg.name

}

# Create a Subnet for WebApp Servers
resource "azurerm_subnet" "app_subnet" {
  address_prefixes     = ["10.0.1.0/24"]
  name                 = "WebServers"
  resource_group_name  = azurerm_resource_group.staging_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  depends_on = [azurerm_resource_group.staging_rg]

}

# Create a Subnet for PostgreSQL Flexible Server
resource "azurerm_subnet" "db_subnet" {
  address_prefixes     = ["10.0.2.0/28"] # 10.0.2.1 - 10.0.2.14
  name                 = "Databases"
  resource_group_name  = azurerm_resource_group.staging_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "fs"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }

  depends_on = [azurerm_virtual_network.vnet]

}

# Create a Subnet for Linux Command VMs
resource "azurerm_subnet" "linux_command_subnet" {
  address_prefixes     = ["10.0.10.0/28"] # 10.0.10.1 - 10.0.10.14
  name                 = "Controllers"
  resource_group_name  = azurerm_resource_group.staging_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  depends_on = [azurerm_resource_group.staging_rg]

}

# Create Public IP for Load Balancer
resource "azurerm_public_ip" "load_balancer_pip" {
  allocation_method   = "Static"
  location            = var.location
  name                = "Load_Balancer-PiP"
  resource_group_name = azurerm_resource_group.staging_rg.name
  sku                 = "Standard"

}

# Create Public IP for Linux Command VM
resource "azurerm_public_ip" "linux_command_pip" {
  allocation_method   = "Static"
  location            = var.location
  name                = "${var.command_vm_name}-PiP"
  resource_group_name = azurerm_resource_group.staging_rg.name

  depends_on = [azurerm_resource_group.staging_rg]

}

# Create 3 Network Interfaces for WebApp VMs
resource "azurerm_network_interface" "nics" {
  count               = var.counter
  name                = "${var.lb_backend_ap_ip_configuration_name}-${count.index + 1}"
  location            = azurerm_resource_group.staging_rg.location
  resource_group_name = azurerm_resource_group.staging_rg.name

  ip_configuration {
    name                          = var.lb_backend_ap_ip_configuration_name
    subnet_id                     = azurerm_subnet.app_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.${count.index + 4}"

  }

  depends_on = [
    azurerm_resource_group.staging_rg,
    azurerm_subnet.app_subnet
  ]

}

# Create NIC for Linux Command VM
resource "azurerm_network_interface" "linux_command-nic" {
  location            = var.location
  name                = "${var.command_vm_name}-NIC"
  resource_group_name = azurerm_resource_group.staging_rg.name

  ip_configuration {
    name                          = var.command_nic_ip_configuration_name
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux_command_pip.id
    subnet_id                     = azurerm_subnet.linux_command_subnet.id

  }

  depends_on = [
    azurerm_resource_group.staging_rg,
    azurerm_subnet.linux_command_subnet
  ]

}

# Create Availability Set
resource "azurerm_availability_set" "availability_set" {
  location                     = var.location
  name                         = "WebServers-Availability_Set"
  resource_group_name          = azurerm_resource_group.staging_rg.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true

}

# Create Private DNS Zone for PostGreSQL
resource "azurerm_private_dns_zone" "dbdns" {
  name                = "${var.db_dns_zone_name}-pdz.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.staging_rg.name

  depends_on = [azurerm_virtual_network.vnet]

}

# Link Private DNS Zone to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "zone_link" {
  name                  = "weightracker"
  private_dns_zone_name = azurerm_private_dns_zone.dbdns.name
  resource_group_name   = azurerm_resource_group.staging_rg.name
  virtual_network_id    = azurerm_virtual_network.vnet.id

  depends_on = [azurerm_virtual_network.vnet]

}
