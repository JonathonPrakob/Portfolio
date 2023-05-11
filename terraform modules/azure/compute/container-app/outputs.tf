output "apim" {
  value = [for name in azurerm_container_app.foo :
    {
      name           = trimprefix(trimsuffix("${name.name}", "-${var.environment}"), "ca-")
      url            = "https://${name.name}.${azurerm_private_dns_zone.foo.name}"
      swagger        = "https://${name.name}.${azurerm_private_dns_zone.foo.name}/swagger/v1/swagger.json"
      content_format = name.tags["content_format"]
    }
  ]
}