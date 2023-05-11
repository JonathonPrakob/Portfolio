This module will bulk create users based on a csv file. The template CSV is located in the module folder as "UserCreateTemplate.csv". You will need to make a copy and modify to your needs


required template fields (all else can be left blank):
displayName, UserPrincipalName, passwordProfile, accountEnabled 
user principal name must match a domain name available in your registered azuread provider
reference: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/user#consent_provided_for_minor

required inputs:
csv_BulkCreateUsers  = 'path to csv file'
example: "${path.module}/UserCreateTemplate.csv"

