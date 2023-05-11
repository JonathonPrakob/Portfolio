### MODULE NAME
container-app

### AUTHORS
Jonathon Prakob

### DESCRIPTION
Deploys a private container app from an azure container registry 

### RESOURCES
azurerm_resource_group.containerapp
    azurerm_log_analytics_workspace.containerapp
    azurerm_container_app_environment.cae
    azurerm_container_app.services
    azurerm_private_dns_zone.containerapp
    azurerm_private_dns_zone_virtual_network_link.link
    azurerm_private_dns_a_record.containerapp


### REQUIRED INPUTS
subnet:  for the container app environment
    type: string

registry: path for azure container registry
    type: string

registry: name of azure container registry
    type: string

secret-name: name of the secret which holds the value for the registry password
    type: string

secret-value: value of the secret which holds the value for the registry password
    type: string

container-images: attributes of container app and container
    type: list(object)
    example:
        [{
            name    = "ca-mc-alert"
            image   = "cfpetacr.azurecr.io/cfpet-mc-alert:84133"
            purpose = "alert service"
            port    = "5000"
            cpu     = 0.25
            memory  = "0.5Gi"
        }]


### OPTIONAL INPUTS
providers: if you need the resource to be created in another subscription other than NP
    type: string

location: resource location
    type: string

environment: dev/qa/staging/etc.
    type: string

vnet-link: name and id of a vnet to link the private dns zone to
    type: list(object)
    example: 
        [{
            vnet-name  = data.azurerm_virtual_network.staging.name
            vnet-id = data.azurerm_virtual_network.staging.id
        }]

environment-variables: specify the name and value of any environment variables
    type: list(object)
    example: 
        [{
            name  = "ASPNETCORE_ENVIRONMENT"
            value = "staging"
        }]

min-replicas: The minimum number of replicas for this container
    type: string

max-replicas: The maximum number of replicas for this container.
    type: string

### OUTPUTS
swagger: 
    name: name of the microservice
    resource: fqdn of the container app
    link: link for open-api


