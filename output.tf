output "webservers_admin_password" {
  value     = var.webapp_vm_admin_password
  sensitive = true

}

output "command_vm_password" {
  value     = var.command_vm_admin_password
  sensitive = true

}

output "lb_pub_ip" {
  value = azurerm_public_ip.load_balancer_pip.ip_address
}

output "controller_ip" {
  value = azurerm_public_ip.linux_command_pip.ip_address
}