### MODULE NAME
dns-zone

### AUTHOR
Jonathon Prakob

### DESCRIPTION
Deploys a private dns zone in azure

### RESOURCES
azurerm_resource_group.group
    azurerm_private_dns_zone.zone
        azurerm_private_dns_zone_virtual_network_link.link
        azurerm_private_dns_a_record.a
        azurerm_private_dns_aaaa_record.aaaa
        azurerm_private_dns_cname_record.cname
        azurerm_private_dns_mx_record.mx
        azurerm_private_dns_ptr_record.ptr
        azurerm_private_dns_srv_record.srv
        azurerm_private_dns_txt_record.txt

### REQUIRED INPUTS
domain_name
    type: string

resource_group_name
    type: string

### OPTIONAL INPUTS
a_record
    type: list(object)

aaaa_record
    type: list(object)

cname_record
    type: list(object)

mx_record
    type: list(object)

ptr_record
    type: list(object)

srv_record
    type: list(object)
    
txt_record
    type: list(object)

vnet_link: virtual networks to link to the dns zone
    typeL list(object)




