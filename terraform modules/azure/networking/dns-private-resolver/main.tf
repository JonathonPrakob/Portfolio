resource "azurerm_private_dns_resolver" "foo" {
  name                = var.resolver_name
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_id  = var.virtual_network_id
  tags = {
    purpose     = "forward dns requests between on-premise and azure"
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

resource "azurerm_private_dns_resolver_inbound_endpoint" "foo" {
  for_each = { for name in var.inbound_endpoint : name.name => name }

  name                    = each.value.name
  private_dns_resolver_id = azurerm_private_dns_resolver.foo.id
  location                = azurerm_private_dns_resolver.foo.location
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = each.value.subnet_id
  }
  tags = {
    purpose = each.value.purpose
    created = "${timestamp()}"
  }
  lifecycle {
    ignore_changes = [
      tags["created"]
    ]
  }
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "foo" {
  for_each = { for name in var.outbound_endpoint : name.name => name }

  name                    = each.value.name
  private_dns_resolver_id = azurerm_private_dns_resolver.foo.id
  location                = azurerm_private_dns_resolver.foo.location
  subnet_id               = each.value.subnet_id
  tags = {
    purpose = each.value.purpose
    created = "${timestamp()}"
  }
  lifecycle {
    ignore_changes = [
      tags["created"]
    ]
  }
}

resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "foo" {
  for_each = { for name in var.ruleset : name.name => name }

  name                                       = each.value.name
  private_dns_resolver_outbound_endpoint_ids = azurerm_private_dns_resolver_outbound_endpoint.foo[each.value.outbound_endpoint_name]
  location                                   = azurerm_private_dns_resolver.foo.location
  resource_group_name                        = var.resource_group_name
  tags = {
    purpose = each.value.purpose
    created = "${timestamp()}"
  }
  lifecycle {
    ignore_changes = [
      tags["created"]
    ]
  }
}

resource "azurerm_private_dns_resolver_virtual_network_link" "foo" {
  for_each = { for name in var.ruleset : name.name => name }

  name                      = each.value.vnet_link_name
  virtual_network_id        = each.value.vnet_link_id
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.foo[each.value.name].id
}

resource "azurerm_private_dns_resolver_forwarding_rule" "foo" {
  for_each = { for name in var.ruleset : name.name => name }

  name                      = each.value.rules.name
  domain_name               = each.value.rules.domain_name
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.foo[each.value.name].id
  enabled                   = each.value.rules.enabled
  dynamic "target_dns_servers" {
    for_each = each.value.rules.dns_servers
    content {
      ip_address = target_dns_servers.value[ip_address]
      port       = target_dns_servers.value[port]
    }
  }
}