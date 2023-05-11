output "custom_domain" {
  value = azurerm_api_management_custom_domain.foo
}

output "private_ip" {
  value = azurerm_api_management.foo.private_ip_addresses
}

