output "LB_public_ip" {
  value = azurerm_public_ip.pub_ip.ip_address
}

output "DB_username" {
  value = azurerm_postgresql_flexible_server.postgres_flex_server.administrator_login
  sensitive = true
}

output "DB_admin_password" {
  value = azurerm_postgresql_flexible_server.postgres_flex_server.administrator_password
  sensitive = true
}

output "admin_password" {
  value = module.VMSS.admin_password
  sensitive = true
}

output "postgresql_flexible_server_database_name" {
  value = azurerm_postgresql_flexible_server_database.postgres.name
  sensitive = true
}

output "azurerm_postgresql_flexible_server" {
  value = azurerm_postgresql_flexible_server.postgres_flex_server.name
  sensitive = true
}