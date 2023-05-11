resource "azurerm_resource_group" "foo" {
  name     = "rg-agw-${var.environment}"
  location = var.location
  tags = {
    purpose     = "application gatway resources"
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

resource "azurerm_public_ip" "foo" {
  name                = "ip-agw-${var.environment}"
  resource_group_name = azurerm_resource_group.foo.name
  location            = azurerm_resource_group.foo.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    purpose     = "application gateway entrypoint"
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

resource "azurerm_application_gateway" "foo" {
  name                = "agw-${var.environment}"
  resource_group_name = azurerm_resource_group.foo.name
  location            = azurerm_resource_group.foo.location
  sku {
    name = var.sku["name"]
    tier = var.sku["tier"]
  }
  autoscale_configuration {
    min_capacity = var.capacity["min"]
    max_capacity = var.capacity["max"]
  }
  identity {
    type         = "UserAssigned"
    identity_ids = var.mi_ids
  }
  dynamic "backend_address_pool" {
    for_each = var.backend_address_pool
    content {
      name         = backend_address_pool.value.name
      fqdns        = backend_address_pool.value.fqdns
      ip_addresses = backend_address_pool.value.ips
    }
  }
  gateway_ip_configuration {
    name      = "${var.environment}-Gateway"
    subnet_id = var.subnet
  }
  frontend_ip_configuration {
    name                 = "${var.environment}FrontendIP"
    public_ip_address_id = azurerm_public_ip.foo.id
  }
  frontend_port {
    name = "${var.environment}FrontendPort"
    port = "443"
  }
  dynamic "ssl_certificate" {
    for_each = { for name in var.ssl_certificate : name.name => name }
    content {
      name                = ssl_certificate.value["name"]
      key_vault_secret_id = ssl_certificate.value["key_vault_secret_id"]
    }
  }
  dynamic "http_listener" {
    for_each = var.http_listener
    content {
      name                           = http_listener.value["name"]
      frontend_ip_configuration_name = "${var.environment}FrontendIP"
      frontend_port_name             = "${var.environment}FrontendPort"
      protocol                       = http_listener.value["protocol"]
      #for multi-site listener
      host_name  = http_listener.value["host_name_single_site"] != null ? http_listener.value["host_name_single_site"] : null
      host_names = http_listener.value["host_name_multi_site"] != null ? http_listener.value["host_name_multi_site"] : null
      #for https
      ssl_certificate_name = http_listener.value["protocol"] != "Http" ? http_listener.value["ssl_certificate_name"] : null
    }
  }
  dynamic "request_routing_rule" {
    for_each = var.routing_rule
    content {
      name                       = request_routing_rule.value["name"]
      rule_type                  = request_routing_rule.value["rule_type"]
      http_listener_name         = request_routing_rule.value["http_listener_name"]
      backend_address_pool_name  = request_routing_rule.value["url_path_map_name"] != null ? null : request_routing_rule.value["backend_address_pool_name"]
      backend_http_settings_name = request_routing_rule.value["url_path_map_name"] != null ? null : request_routing_rule.value["backend_http_settings_name"]
      priority                   = request_routing_rule.value["priority"]
      url_path_map_name          = request_routing_rule.value["rule_type"] != "Basic" ? request_routing_rule.value["url_path_map_name"] : null
    }
  }
  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                                = backend_http_settings.value["name"]
      cookie_based_affinity               = backend_http_settings.value["cookie_based_affinity"]
      port                                = backend_http_settings.value["port"]
      protocol                            = backend_http_settings.value["protocol"]
      request_timeout                     = backend_http_settings.value["request_timeout"] != null ? backend_http_settings.value["request_timeout"] : null
      probe_name                          = backend_http_settings.value["probe_name"] != null ? backend_http_settings.value["probe_name"] : null
      pick_host_name_from_backend_address = backend_http_settings.value["pick_host_name_from_backend_address"]
      host_name                           = backend_http_settings.value["pick_host_name_from_backend_address"] != true ? backend_http_settings.value["host_name"] : null
    }
  }
  dynamic "probe" {
    for_each = var.probe != [] ? var.probe : []
    content {
      name                                      = probe.value["name"]
      protocol                                  = probe.value["protocol"]
      interval                                  = probe.value["interval"]
      path                                      = probe.value["path"]
      timeout                                   = probe.value["timeout"]
      unhealthy_threshold                       = probe.value["unhealthy_threshold"]
      pick_host_name_from_backend_http_settings = probe.value["pick_host_name_from_backend_http_settings"]
      host                                      = probe.value["pick_host_name_from_backend_http_settings"] != "true" ? probe.value["host"] : null
    }
  }
  dynamic "url_path_map" {
    for_each = var.path_rule != [] ? var.path_rule : []
    content {
      name                               = url_path_map.value["name"]
      default_backend_address_pool_name  = url_path_map.value["default_backend_address_pool"]
      default_backend_http_settings_name = url_path_map.value["default_backend_http_settings"]
      dynamic "path_rule" {
        for_each = var.path_rule != [] ? var.path_rule : []
        content {
          name                       = path_rule.value["name"]
          paths                      = path_rule.value["paths"]
          backend_http_settings_name = path_rule.value["path_backend_http_settings"]
          backend_address_pool_name  = path_rule.value["path_backend_address_pool"]
        }
      }
    }
  }
  tags = {
    purpose     = "${var.environment} application gateway"
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