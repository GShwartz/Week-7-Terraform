#creates a resource: public ip
resource "azurerm_public_ip" "pub_ip" {
  name                = "VMSS-PiP"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = random_string.fqdn.result
  sku                 = "Standard"

}

#creates a resource: load balancer
resource "azurerm_lb" "LB" {
  name                = "VMSS-LB"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

#assign public ip to load balancer
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pub_ip.id
  }

}

#creates a resource of backend pool of VMs for the load balancer to use to apply rules for
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.LB.id
  name            = "BackEndAddressPool"

}

#creates a resource of load balancer prob to monitor and allow the load balancer to distribute traffic on port 8080
resource "azurerm_lb_probe" "LB_probe" {
  loadbalancer_id     = azurerm_lb.LB.id
  name                = "WebProbe"
  protocol            = "Tcp"
  port                = 8080
  interval_in_seconds = 5

}

#resource that connects the load balancer with the prob and the backend pool
resource "azurerm_lb_rule" "lbnatrule" {
  #  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.LB.id
  name                           = "Web"
  protocol                       = "Tcp"
  frontend_port                  = var.application_port
  backend_port                   = var.application_port
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.LB_probe.id
  disable_outbound_snat          = true

}

#creates a resource that direct incoming traffic from predefined ports to VMs in port 22 (for SSHin to the machines)
resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = azurerm_resource_group.rg.name
  name                           = "SSH"
  loadbalancer_id                = azurerm_lb.LB.id
  protocol                       = "Tcp"
  frontend_port_start            = 221
  frontend_port_end              = 228
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"

}

#allowing the backend pool to access the internet
resource "azurerm_lb_outbound_rule" "LB_out" {
  loadbalancer_id         = azurerm_lb.LB.id
  name                    = "WEB"
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
  allocated_outbound_ports = 64000

  frontend_ip_configuration {
    name = "PublicIPAddress"
  }
}

resource "azurerm_availability_set" "as" {
  location            = var.location
  name                = "as"
  resource_group_name = var.rg_name
}

