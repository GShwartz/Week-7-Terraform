# Create a Load Balancer
resource "azurerm_lb" "load_balancer" {
  location            = var.location
  name                = "Load_Balancer"
  resource_group_name = azurerm_resource_group.staging_rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.load_balancer_pip.id
  }

  sku = "Standard"

}

# Create a Load Balancer Address Pool
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "BackEndAddressPool"

  depends_on = [azurerm_lb.load_balancer]

}

# Create a Health Probe for HTTP Access
resource "azurerm_lb_probe" "web_probe" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "HTTP_Probe"
  port            = 8080

  depends_on = [azurerm_lb.load_balancer]

}

# Create a Health Probe for RDP Access
resource "azurerm_lb_probe" "rdp_probe" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "RDP_Probe"
  port            = 3389

  depends_on = [azurerm_lb.load_balancer]

}

# Link App-Servers NIC to LB Address Pool
resource "azurerm_network_interface_backend_address_pool_association" "apps_nics_association" {
  count                   = 2
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
  ip_configuration_name   = var.lb_backend_ap_ip_configuration_name
  network_interface_id    = azurerm_network_interface.nics[count.index].id

}