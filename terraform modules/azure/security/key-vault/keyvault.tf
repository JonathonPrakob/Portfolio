resource "azurerm_resource_group" "foo" {
  name     = "rg-keyvault-${var.environment}"
  location = "North Central US"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "foo" {
  name                = "ipg-kv-${var.environment}"
  sku_name            = "standard"
  resource_group_name = azurerm_resource_group.foo.name
  location            = azurerm_resource_group.foo.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
}