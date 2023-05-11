output "id" {
  value = azurerm_key_vault.foo.id
}

output "rg_name" {
  value = azurerm_key_vault.foo.resource_group_name
}

output "rg_id" {
  value = azurerm_resource_group.foo.id
}