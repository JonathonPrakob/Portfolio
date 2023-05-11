variable "location" {
  type    = string
  default = "North Central US"
}

variable "environment" {
  type    = string
  default = ""
}

variable "key_vault_id" {
  type = string
}

variable "subnet" {
  type = string
}

variable "sku" {
  type = object({
    name = string
    tier = string
  })
  default = {
    name = "Standard_v2"
    tier = "Standard_v2"
  }
}

variable "mi_ids" {
  type = list(string)
}

variable "path_rule" {
  type = list(object({
    name                          = string
    paths                         = list(string)
    path_backend_http_settings    = string
    path_backend_address_pool     = string
    default_backend_http_settings = string
    default_backend_address_pool  = string
  }))
}

variable "capacity" {
  type = object({
    min = string
    max = string
  })
}

variable "backend_address_pool" {
  type = list(object({
    name  = string
    fqdns = optional(list(string))
    ips   = optional(list(string))
  }))
}

variable "probe" {
  type = list(object({
    name                                      = string
    protocol                                  = string
    interval                                  = string
    path                                      = string
    timeout                                   = string
    unhealthy_threshold                       = string
    pick_host_name_from_backend_http_settings = string
    host                                      = optional(string)
  }))
  default = []
}

variable "ssl_certificate" {
  type = list(object({
    name                = string
    key_vault_secret_id = string
  }))
  default = []
}

variable "http_listener" {
  type = list(object({
    name                  = string
    protocol              = string
    host_name_single_site = optional(string)
    host_name_multi_site  = optional(list(string))
    ssl_certificate_name  = optional(string)
  }))
}

variable "routing_rule" {
  type = list(object({
    name                       = string
    http_listener_name         = string
    backend_http_settings_name = optional(string)
    priority                   = string
    url_path_map_name          = optional(string)
    rule_type                  = string
    backend_address_pool_name  = optional(string)
  }))
}

variable "backend_http_settings" {
  type = list(object({
    name                                = string
    cookie_based_affinity               = string
    port                                = string
    protocol                            = string
    request_timeout                     = optional(string)
    probe_name                          = optional(string)
    host_name                           = optional(string)
    pick_host_name_from_backend_address = string
  }))
}
