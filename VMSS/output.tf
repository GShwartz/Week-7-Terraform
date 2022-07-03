# outputs the admin password to root in order to output to user at completion
output "admin_password" {
  value = azurerm_linux_virtual_machine_scale_set.VMSS.admin_password
}
