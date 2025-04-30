resource "azurerm_storage_account" "storage" {
  name                     = "emtenanproject"  # must be globally unique!
  resource_group_name      = azurerm_resource_group.project.name
  location                 = azurerm_resource_group.project.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_container" "container" {
  name                  = "appfiles"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "container"  # or "private" or "blob"
}

# Generate SAS Token for the storage account
data "azurerm_storage_account_sas" "appfiles_sas" {
  connection_string = azurerm_storage_account.storage.primary_connection_string

  https_only = true
  start      = "2025-04-29T00:00:00Z"  # تأكد من أنه في المستقبل
  expiry     = "2025-05-30T00:00:00Z"  # تأكد من أنه بعد فترة مناسبة

  services {
    blob  = true
    file  = true
    queue = false
    table = false
  }

  resource_types {
    service   = false
    container = true
    object    = true
  }

  permissions {
    read    = true
    write   = true
    list    = true
    create  = true
    delete  = false
    update  = true
    process = true
    tag     = false
    filter  = false
    add     = false
  }
}

# مفاتيح الخروج (Outputs)
output "storage_account_primary_access_key" {
  sensitive = true
  value     = azurerm_storage_account.storage.primary_access_key
}

output "storage_container_name" {
  value = azurerm_storage_container.container.name
}

# Output جديد: SAS URL
output "storage_container_sas_url" {
  value     = "https://${azurerm_storage_account.storage.name}.blob.core.windows.net/${azurerm_storage_container.container.name}${data.azurerm_storage_account_sas.appfiles_sas.sas}"
  sensitive = true
}
