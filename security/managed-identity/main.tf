resource "azurerm_user_assigned_identity" "foo" {
  location            = var.location
  name                = var.name
  resource_group_name = var.rg_name
  tags = {
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
