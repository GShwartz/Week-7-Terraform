# Create a Flexible PostgreSQL Server
resource "azurerm_postgresql_flexible_server" "server" {
  resource_group_name    = azurerm_resource_group.staging_rg.name
  delegated_subnet_id    = azurerm_subnet.db_subnet.id
  location               = var.location
  name                   = var.db_server_name
  version                = "13"
  administrator_login    = var.db_user
  administrator_password = var.db_password
  storage_mb             = 131072
  sku_name               = "GP_Standard_D2s_v3"
  backup_retention_days  = 7
  private_dns_zone_id    = azurerm_private_dns_zone.dbdns.id
  zone                   = "1"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.zone_link]

}

# Create Database
resource "azurerm_postgresql_flexible_server_database" "database" {
  name      = var.db_server_name
  server_id = azurerm_postgresql_flexible_server.server.id
  collation = "en_US.UTF8"
  charset   = "UTF8"

  depends_on = [azurerm_postgresql_flexible_server.server]

}

# Configure Flexible PostgreSQL Server
resource "azurerm_postgresql_flexible_server_configuration" "dbconf" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.server.id
  value     = "off"

  depends_on = [azurerm_postgresql_flexible_server_database.database]

}



