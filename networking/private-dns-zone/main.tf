resource "azurerm_private_dns_zone" "foo" {
  name                = var.domain_name
  resource_group_name = var.resource_group_name
  tags = {
    purpose     = "internal dns for ${var.domain_name}"
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
  for_each = { for name in var.a_record : name.name => name }

  name                = each.value.name
  zone_name           = azurerm_private_dns_zone.foo.name
  resource_group_name = azurerm_private_dns_zone.foo.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.value
}

resource "azurerm_private_dns_aaaa_record" "foo" {
  for_each = { for name in var.aaaa_record : name.name => name }

  name                = each.value.name
  zone_name           = azurerm_private_dns_zone.foo.name
  resource_group_name = azurerm_private_dns_zone.foo.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.value
}

resource "azurerm_private_dns_cname_record" "foo" {
  for_each = { for name in var.cname_record : name.name => name }

  name                = each.value.name
  zone_name           = azurerm_private_dns_zone.foo.name
  resource_group_name = azurerm_private_dns_zone.foo.resource_group_name
  ttl                 = each.value.ttl
  record              = each.value.value
}

resource "azurerm_private_dns_mx_record" "foo" {
  for_each = { for name in var.mx_record : name.name => name }

  name                = each.value.name
  zone_name           = azurerm_private_dns_zone.foo.name
  resource_group_name = azurerm_private_dns_zone.foo.resource_group_name
  ttl                 = each.value.ttl
  dynamic "record" {
    for_each = each.value.value
    content {
      preference = record.value[preference]
      exchange   = record.value[exchange]
    }
  }
}

resource "azurerm_private_dns_ptr_record" "foo" {
  for_each = { for name in var.ptr_record : name.name => name }

  name                = each.value.name
  zone_name           = azurerm_private_dns_zone.foo.name
  resource_group_name = azurerm_private_dns_zone.foo.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.value
}

resource "azurerm_private_dns_srv_record" "foo" {
  for_each = { for name in var.srv_record : name.name => name }

  name                = each.value.name
  zone_name           = azurerm_private_dns_zone.foo.name
  resource_group_name = azurerm_private_dns_zone.foo.resource_group_name
  ttl                 = each.value.ttl
  dynamic "record" {
    for_each = each.value.value
    content {
      priority = record.value[priority]
      weight   = record.value[weight]
      port     = record.value[port]
      target   = record.value[target]
    }
  }
}

resource "azurerm_private_dns_txt_record" "foo" {
  for_each = { for name in var.txt_record : name.name => name }

  name                = each.value.name
  zone_name           = azurerm_private_dns_zone.foo.name
  resource_group_name = azurerm_private_dns_zone.foo.resource_group_name
  ttl                 = each.value.ttl
  dynamic "record" {
    for_each = each.value.value
    content {
      value = record.value[value]
    }
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "foo" {
  for_each = { for vnet in var.vnet_link : vnet.vnet_name => vnet }

  name                  = each.value.vnet_name
  resource_group_name   = azurerm_private_dns_zone.foo.resource_group_name
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