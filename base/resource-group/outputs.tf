output "info" {
  value = {
    id = azurerm_resource_group.foo.id
    name = azurerm_resource_group.foo.name
    location = azurerm_resource_group.foo.location
  }
}