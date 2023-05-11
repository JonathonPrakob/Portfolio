### MODULE NAME
resource-group

### AUTHOR
Jonathon Prakob

### DESCRIPTION
deploy a resource lock

### RESOURCES
azurerm_management_lock.lock

### REQUIRED INPUTS
lock_level: CanNotDelete or ReadOnly
    type: string

scope: ID of subscription, resource group, or resource

### OPTIONAL INPUTS
notes: information about the lock
    type: string





