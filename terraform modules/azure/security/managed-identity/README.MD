### MODULE NAME
managed-identity

### AUTHOR
Jonathon Prakob

### DESCRIPTION
Deploys a user assigned managed identity

### RESOURCES
azurerm_user_assigned_identity.foo

### REQUIRED INPUTS
name: name of the managed identity
    type: string

rg_name: name of the resource group to deploy the managed identity to
    type: string

### OPTIONAL INPUTS
location: location
    type: string




