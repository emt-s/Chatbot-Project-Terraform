resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = "emtenan-flexible-postgres"
  location               = azurerm_resource_group.project.location
  resource_group_name    = azurerm_resource_group.project.name
  administrator_login    = "psqladmin"
  administrator_password = "AsdZx123"

  sku_name   = "B_Standard_B1ms"
  version    = "13"
  storage_mb = 65536

  backup_retention_days = 7
  zone                 = "1"   # Optional, depends on region

}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name                = "AllowAllIps"
  server_id           = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

# Create the database 
resource "azurerm_postgresql_flexible_server_database" "appdb" {
  name      = "appdb"
  server_id = azurerm_postgresql_flexible_server.postgres.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
