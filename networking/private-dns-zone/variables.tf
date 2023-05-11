variable "domain_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "a_record" {
  type = list(object({
    name  = string
    value = list(string)
    ttl   = string
  }))
  default = []
}

variable "aaaa_record" {
  type = list(object({
    name  = string
    value = list(string)
    ttl   = string
  }))
  default = []
}

variable "caa_record" {
  type = list(object({
    name = string
    value = list(object({
      flags = string
      tag   = string
      value = string
    }))
    ttl = string
  }))
  default = []
}

variable "cname_record" {
  type = list(object({
    name  = string
    value = list(string)
    ttl   = string
  }))
  default = []
}

variable "mx_record" {
  type = list(object({
    name = string
    value = list(object({
      preference = string
      exchange   = string
    }))
    ttl = string
  }))
  default = []
}

variable "srv_record" {
  type = list(object({
    name = string
    value = list(object({
      priority = string
      weight   = string
      port     = string
      target   = string
    }))
    ttl = string
  }))
  default = []
}

variable "txt_record" {
  type = list(object({
    name  = string
    value = list(string)
    ttl   = string
  }))
  default = []
}

variable "ptr_record" {
  type = list(object({
    name  = string
    value = list(string)
    ttl   = string
  }))
  default = []
}

variable "ns_record" {
  type = list(object({
    name  = string
    value = list(string)
    ttl   = string
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