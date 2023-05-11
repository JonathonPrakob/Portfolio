resource "azurerm_private_dns_zone" "foo" {
  name                = azurerm_container_app_environment.foo.default_domain
  resource_group_name = azurerm_resource_group.foo.name
  tags = {
    purpose     = "non-custom domain: resolves the Container Apps environment's default domain to the static IP address of the Container Apps environment"
    owner       = "Cloud Operations"
    created     = "${timestamp()}"
    provisioner = "terraform"
  }
  lifecycle {
    ignore_changes = [
      tags["created"]
    ]
  }
}

resource "azurerm_private_dns_a_record" "foo" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.foo.name
  resource_group_name = azurerm_resource_group.foo.name
  ttl                 = 300
  records             = [azurerm_container_app_environment.foo.static_ip_address]
  tags = {
    purpose     = "resolves the Container Apps environment's default domain to the static IP address of the Container Apps environment "
    owner       = "Cloud Operations"
    created     = "${timestamp()}"
    provisioner = "terraform"
  }
  lifecycle {
    ignore_changes = [
      tags["created"]
    ]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "foo" {
  for_each = { for vnet in var.vnet_link : vnet.vnet_name => vnet }

  name                  = each.value.vnet_name
  resource_group_name   = azurerm_resource_group.foo.name
  private_dns_zone_name = azurerm_private_dns_zone.foo.name
  virtual_network_id    = each.value.vnet_id
  tags = {
    purpose     = "link vnet to private dns zone"
    owner       = "Cloud Operations"
    created     = "${timestamp()}"
    provisioner = "terraform"
  }
  lifecycle {
    ignore_changes = [
      tags["created"]
    ]
  }
}