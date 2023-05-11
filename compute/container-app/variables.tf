variable "location" {
  type    = string
  default = "North Central US"
}

variable "registry" {
  description = "name of azure container registry"
  type        = string
}

variable "secret_name" {
  type = string
}

variable "secret_value" {
  type      = string
  sensitive = true
}

variable "environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "vnet_link" {
  type = list(object({
    vnet_name = string
    vnet_id   = string
  }))
  default = []
}

variable "environment" {
  type    = string
  default = ""
}

variable "subnet" {
  type = string
}

variable "container_images" {
  type = list(object({
    name           = string
    image          = string
    purpose        = string
    port           = string
    cpu            = string
    memory         = string
    content_format = string
  }))
}

variable "min_replicas" {
  type    = string
  default = 0
}

variable "max_replicas" {
  type    = string
  default = 10
}