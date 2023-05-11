locals {
  users = csvdecode(file(var.csv_BulkCreateUsers))
}

resource "azuread_user" "create" {
  for_each = { for user in local.users : user.display_name => user }

  user_principal_name         = each.value.user_principal_name
  display_name                = each.value.display_name
  account_enabled             = each.value.account_enabled
  password                    = each.value.password
  age_group                   = each.value.age_group
  business_phones             = [each.value.business_phones] != "" ? [each.value.business_phones] : []
  city                        = each.value.city
  company_name                = each.value.company_name
  consent_provided_for_minor  = each.value.consent_provided_for_minor
  cost_center                 = each.value.cost_center
  country                     = each.value.country
  department                  = each.value.department
  disable_password_expiration = each.value.disable_password_expiration != "" ? each.value.disable_password_expiration : null
  disable_strong_password     = each.value.disable_strong_password != "" ? each.value.disable_strong_password : null
  division                    = each.value.division
  employee_id                 = each.value.employee_id
  employee_type               = each.value.employee_type != "" ? each.value.employee_type : null
  fax_number                  = each.value.fax_number
  force_password_change       = each.value.force_password_change != "" ? each.value.force_password_change : null
  given_name                  = each.value.given_name
  job_title                   = each.value.job_title
  mail                        = each.value.mail
  mail_nickname               = each.value.mail_nickname
  manager_id                  = each.value.manager_id
  mobile_phone                = each.value.mobile_phone
  office_location             = each.value.office_location
  onpremises_immutable_id     = each.value.onpremises_immutable_id
  other_mails                 = [each.value.other_mails] != "" ? split(",", replace(each.value.other_mails, "/\\s+/", "")) : []
  postal_code                 = each.value.postal_code
  preferred_language          = each.value.preferred_language != "" ? each.value.preferred_language : null
  show_in_address_list        = each.value.show_in_address_list != "" ? each.value.show_in_address_list : null
  state                       = each.value.state
  street_address              = each.value.street_address
  surname                     = each.value.surname
  usage_location              = each.value.usage_location
}


