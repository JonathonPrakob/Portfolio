resource "azurerm_resource_group" "foo" {
  name     = var.name
  location = var.location
  tags = {
    purpose     = var.purpose
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