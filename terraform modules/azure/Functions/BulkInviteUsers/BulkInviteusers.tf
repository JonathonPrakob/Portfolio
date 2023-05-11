locals {
  users = csvdecode(file(var.csv_BulkInviteUsers))
}

resource "azuread_invitation" "invite" {
  for_each = { for user in local.users : user.user_display_name => user }

  user_email_address = each.value.user_email_address
  user_display_name  = each.value.user_display_name
  user_type          = each.value.user_type
  redirect_url       = each.value.redirect_url
  message {
    body = each.value.message
  }
}
