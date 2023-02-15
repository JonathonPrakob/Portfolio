variable "var_management_group" {
  type    = string
  default = "RootManagementGroup"
}
variable "var_not_scopes" {
  type    = list
  default = []
  description = "use '/subscriptions/(enter subscription ID)/resourceGroups/(enter resource group id)' to set scope(s)"
}