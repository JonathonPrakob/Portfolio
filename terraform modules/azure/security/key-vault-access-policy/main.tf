data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "foo" {
  key_vault_id            = var.key_vault_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = var.object_id
  certificate_permissions = var.permissions.certificate
  key_permissions         = var.permissions.key
  secret_permissions      = var.permissions.secret
  storage_permissions     = var.permissions.storage
}

