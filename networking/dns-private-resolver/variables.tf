variable "resolver_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "virtual_network_id" {
  type = string
}

variable "inbound_endpoint" {
  type = list(object({
    name      = string
    subnet_id = string
    purpose   = string
  }))
  default = []
}

variable "outbound_endpoint" {
  type = list(object({
    name      = string
    subnet_id = string
    purpose   = string
  }))
  default = []
}

variable "ruleset" {
  type = list(object({
    name                   = string
    purpose                = string
    outbound_endpoint_name = string
    rules = object({
      name        = string
      domain_name = string
      enabled     = bool
      dns_servers = list(object({
        ip_address = string
        port       = string
      }))
    })
  }))
  default = []
}