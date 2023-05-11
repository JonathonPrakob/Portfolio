variable "location" {
  type    = string
  default = "North Central US"
}

variable "mi_ids" {
  type    = list(string)
  default = null
}

variable "mi_client_id" {
  type    = string
  default = null
}

variable "key_vault_secret_id" {
  type = string
}

variable "environment" {
  type    = string
  default = ""
}

variable "sku" {
  type = object({
    name     = string
    capacity = string
  })
  default = {
    capacity = "Developer"
    name     = "1"
  }
}

variable "publisher_name" {
  type = string
}

variable "publisher_email" {
  type = string
}

variable "apim_subnet_id" {
  type = string
}

variable "api" {
  type = list(object({
    name           = string
    swagger        = string
    url            = string
    content_format = string
  }))
}

variable "subscription" {
  type = list(object({
    name          = string
    product_id    = string
    allow_tracing = string
  }))
  default = []
}

variable "product" {
  type = list(object({
    approval_required     = string
    name                  = string
    published             = string
    description           = string
    subscription_required = string
    api_name              = list(string)
  }))
  default = []
}

variable "custom_domain" {
  type = object({
    management = optional(list(object({
      host_name                    = string
      negotiate_client_certificate = string
    })))
    scm = optional(list(object({
      host_name                    = string
      negotiate_client_certificate = string
    })))
    developer_portal = optional(list(object({
      host_name                    = string
      negotiate_client_certificate = string
    })))
    gateway = optional(list(object({
      host_name                    = string
      negotiate_client_certificate = string
      default_ssl_binding          = string
    })))
  })
  default = null
}