resource "azurerm_public_ip" "p2s" {
  name                = "tf-p2s"
  resource_group_name = azurerm_resource_group.containers.name
  location            = azurerm_resource_group.containers.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    purpose     = "assigned to vnet gateway"
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

resource "azurerm_virtual_network_gateway" "p2s" {
  type                = "Vpn"
  sku                 = "VpnGw1"
  resource_group_name = azurerm_resource_group.containers.name
  name                = "tf-p2s"
  location            = azurerm_resource_group.containers.location
  ip_configuration {
    subnet_id            = azurerm_subnet.GatewaySubnet.id
    public_ip_address_id = azurerm_public_ip.p2s.id
  }
  vpn_client_configuration {
    address_space        = [var.address_space]
    aad_tenant           = "https://login.microsoftonline.com/${var.tenant}/"
    aad_audience         = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
    aad_issuer           = "https://sts.windows.net/${var.tenant}/"
    vpn_client_protocols = ["OpenVPN"]
    vpn_auth_types       = ["AAD"]
  }
  tags = {
    purpose     = "allow local client to connect to azure resources via P2S VPN"
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