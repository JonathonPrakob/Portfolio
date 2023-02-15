This module will deny resource creation unless these tags are included:
1. creator/created by/createdby
2. purpose

This module will also automatically append the resource creation time in a 'created' tag

required inputs:
var_management_group = 'Management Group ID'
purpose: set the scope for where you want the policy to assign. Default is 'RootManagementGroup'

optional inputs:
var_not_scopes = [
    '/subscriptions/(enter subscription ID)/resourceGroups/(enter resource group id)'
]
purpose: set an exemption under the policy scope. Default is empty
