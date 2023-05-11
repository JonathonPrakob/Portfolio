variable "object_id" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "permissions" {
  type = object({
    certificate = optional(list(string))
    key         = optional(list(string))
    secret      = optional(list(string))
    storage     = optional(list(string))
  })
}