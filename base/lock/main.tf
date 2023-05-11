data "azurerm_subscription" "current" {
}

resource "azurerm_management_lock" "foo" {
  name       = var.lock_level
  scope      = var.scope
  lock_level = var.lock_level
  notes      = var.notes
}