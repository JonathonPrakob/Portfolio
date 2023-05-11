resource "azurerm_resource_group" "vpn" {
  name     = "tf-p2s-vpn"
  location = "East US"
  tags = {
    purpose     = "group container resources"
    creator     = var.creator
    created     = "${timestamp()}"
    provisioner = "terraform"
  }
  lifecycle {
    ignore_changes = [
      tags["created"]
    ]
  }
}

resource "azurerm_virtual_network" "vpn" {
  name                = "tf-p2s-vpn"
  location            = azurerm_resource_group.containers.location
  resource_group_name = azurerm_resource_group.containers.name
  address_space       = ["10.0.0.0/16"]
  tags = {
    purpose     = "host container resources"
    creator     = var.creator
    created     = "${timestamp()}"
    provisioner = "terraform"
  }
  lifecycle {
    ignore_changes = [
      tags["created"]
    ]
  }
}

#address pool for vpn
resource "azurerm_subnet" "GatewaySubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.containers.name
  virtual_network_name = azurerm_virtual_network.containers.name
  address_prefixes     = ["10.0.8.0/24"]
}



