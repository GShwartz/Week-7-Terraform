# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

#calling module VMSS
module "VMSS" {
  source         = "./VMSS"
  rg_name       = var.rg_name
  location       = var.location
  VMSS_size      = var.size
  VMSS_nsg_id    = azurerm_network_security_group.VMSS_nsg.id
  VMSS_subnet_id = azurerm_subnet.vmss-subnet.id
  BEpool_id      = azurerm_lb_backend_address_pool.backend_pool.id
  LB_natpool_id  = azurerm_lb_nat_pool.lbnatpool.id
  admin_user     = var.admin_user
  admin_password = var.admin_password
  application_port = var.application_port
  capacity = var.capacity
  maximum = var.maximum
  minimum = var.minimum
}

#create random string for unique and random usage
resource "random_string" "fqdn" {
  length  = 6
  special = false
  upper   = false
  number  = false
}



