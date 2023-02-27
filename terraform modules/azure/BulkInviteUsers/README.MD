This module will bulk invite users based on a csv file. The template CSV is located in the module folder as "UserInviteTemplate.csv". You will need to make a copy and modify to your needs

required template fields: redirect_url and user_email_address
reference: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/invitation

required inputs:
csv_BulkInviteUsers = 'path to csv file'
example: "${path.module}/UserInviteTemplate.csv"

