resource "azurerm_resource_group" "foo" {
  name     = "rg-apim-${var.environment}"
  location = var.location
  tags = {
    purpose     = "apim resources"
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

resource "azurerm_api_management" "foo" {
  name                 = "apim-hartville-${var.environment}"
  location             = azurerm_resource_group.foo.location
  resource_group_name  = azurerm_resource_group.foo.name
  sku_name             = "${var.sku.name}_${var.sku.capacity}"
  publisher_name       = var.publisher_name
  publisher_email      = var.publisher_email
  virtual_network_type = "Internal"
  virtual_network_configuration {
    subnet_id = var.apim_subnet_id
  }
  identity {
    type         = "UserAssigned"
    identity_ids = var.mi_ids
  }
  tags = {
    purpose     = "apim for ${var.environment}"
    owner       = "Cloud Operations"
    created     = timestamp()
    provisioner = "terraform"
  }
  lifecycle {
    ignore_changes = [
      tags["created"],
      #casing of resource id of subnet in apim json and resource id of subnet in tf data do not match all the time
      virtual_network_configuration["subnet_id"]
    ]
  }
}

resource "azurerm_api_management_custom_domain" "foo" {
  count = var.custom_domain == null ? 0 : 1

  api_management_id = azurerm_api_management.foo.id
  dynamic "management" {
    for_each = var.custom_domain.management != null ? var.custom_domain.management : []
    content {
      host_name                       = management.value["host_name"]
      key_vault_id                    = var.key_vault_secret_id
      negotiate_client_certificate    = management.value["negotiate_client_certificate"]
      ssl_keyvault_identity_client_id = var.mi_client_id
    }
  }
  dynamic "gateway" {
    for_each = var.custom_domain.gateway != null ? var.custom_domain.gateway : []
    content {
      host_name                       = gateway.value["host_name"]
      key_vault_id                    = var.key_vault_secret_id
      negotiate_client_certificate    = gateway.value["negotiate_client_certificate"]
      default_ssl_binding             = gateway.value["default_ssl_binding"]
      ssl_keyvault_identity_client_id = var.mi_client_id
    }
  }
  dynamic "developer_portal" {
    for_each = var.custom_domain.developer_portal != null ? var.custom_domain.developer_portal : []
    content {
      host_name                       = developer_portal.value["host_name"]
      key_vault_id                    = var.key_vault_secret_id
      negotiate_client_certificate    = developer_portal.value["negotiate_client_certificate"]
      ssl_keyvault_identity_client_id = var.mi_client_id
    }
  }
  dynamic "scm" {
    for_each = var.custom_domain.scm != null ? var.custom_domain.scm : []
    content {
      host_name                       = scm.value["host_name"]
      key_vault_id                    = var.key_vault_secret_id
      negotiate_client_certificate    = scm.value["negotiate_client_certificate"]
      ssl_keyvault_identity_client_id = var.mi_client_id
    }
  }
}

resource "azurerm_api_management_subscription" "subscription" {
  for_each = { for name in var.subscription : name.name => name }

  api_management_name = azurerm_api_management.foo.name
  resource_group_name = azurerm_resource_group.foo.name
  display_name        = each.value.name
  product_id          = each.value.product_id
  allow_tracing       = each.value.allow_tracing
}

resource "azurerm_api_management_product" "foo" {
  for_each = { for name in var.product : name.name => name }

  api_management_name   = azurerm_api_management.foo.name
  resource_group_name   = azurerm_resource_group.foo.name
  approval_required     = each.value.approval_required
  display_name          = each.value.name
  product_id            = each.value.name
  published             = each.value.published
  subscription_required = each.value.subscription_required
  description           = each.value.description
}

resource "azurerm_api_management_product_api" "foo" {
  for_each = { for name in var.product : name.name => name }

  api_management_name = azurerm_api_management.foo.name
  resource_group_name = azurerm_resource_group.foo.name
  product_id          = azurerm_api_management_product.foo[each.value.name].id
  api_name            = each.value.api_name
}



resource "azurerm_api_management_api" "foo" {
  for_each = { for link in var.api : link.name => link }

  name                  = each.value.name
  api_management_name   = azurerm_api_management.foo.name
  resource_group_name   = azurerm_resource_group.foo.name
  revision              = "1"
  display_name          = each.value.name
  path                  = each.value.name
  protocols             = ["https"]
  service_url           = each.value.url
  subscription_required = false
  import {
    #https://learn.microsoft.com/en-us/javascript/api/@azure/arm-apimanagement/contentformat?view=azure-node-latest
    content_format = each.value.content_format
    content_value  = each.value.swagger
  }
}
