resource "azurerm_resource_group" "foo" {
  name     = "rg-containerapp-${var.environment}"
  location = var.location
  tags = {
    purpose     = "container app resources"
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

resource "azurerm_log_analytics_workspace" "foo" {
  name                = "log-containerapp-${var.environment}"
  location            = azurerm_resource_group.foo.location
  resource_group_name = azurerm_resource_group.foo.name
  tags = {
    purpose     = "store logs for container app environment"
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


resource "azurerm_container_app_environment" "foo" {
  name                       = "cae-${var.environment}"
  location                   = azurerm_resource_group.foo.location
  resource_group_name        = azurerm_resource_group.foo.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.foo.id
  infrastructure_subnet_id   = var.subnet

  internal_load_balancer_enabled = true
  tags = {
    purpose     = "vnet boundary for container apps"
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

resource "azurerm_container_app" "foo" {
  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.foo
  ]
  for_each = { for service in var.container_images : service.name => service }

  name                         = "${each.value.name}-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.foo.id
  resource_group_name          = azurerm_resource_group.foo.name
  revision_mode                = "Single"
  identity {
    type = "SystemAssigned"
  }
  registry {
    server               = var.registry
    username             = var.secret_name
    password_secret_name = var.secret_name
  }
  secret {
    name  = var.secret_name
    value = var.secret_value
  }
  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas
    container {
      name   = "${each.value.name}-${var.environment}"
      image  = each.value.image
      cpu    = each.value.cpu
      memory = each.value.memory
      startup_probe {
        port      = 5000
        transport = "TCP"
        timeout   = 30
      }
      readiness_probe {
        port      = 5000
        transport = "TCP"
        timeout   = 30
      }
      dynamic "env" {
        for_each = var.environment_variables
        content {
          name  = env.value["name"]
          value = env.value["value"]
        }
      }
    }
  }
  ingress {
    external_enabled = true
    traffic_weight {
      percentage      = "100"
      latest_revision = true
    }
    target_port                = each.value.port
    allow_insecure_connections = false
  }
  tags = {
    purpose        = each.value.purpose
    owner          = "Cloud Operations"
    created        = "${timestamp()}"
    provisioner    = "terraform"
    content_format = each.value.content_format
  }
  lifecycle {
    ignore_changes = [
      tags["created"],
      template.0.container.0.image,
      template.0.container.0.startup_probe,
      template.0.container.0.readiness_probe,
      secret,
      registry
    ]
  }
}
