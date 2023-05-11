### MODULE NAME
key-vault-access-policy

### AUTHOR
Jonathon Prakob

### DESCRIPTION
This module assigns access policies to a key vault

### RESOURCES
azurerm_key_vault_access_policy.policy

### REQUIRED INPUTS
object_id: who will be assigned the permissions
    type: string

permissions: what permissions will be assigned
    type: object
    example: 
        permissions = {
        certificate = ["Get"]
    }




