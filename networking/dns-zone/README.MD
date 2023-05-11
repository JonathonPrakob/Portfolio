### MODULE NAME
dns-zone

### AUTHOR
Jonathon Prakob

### DESCRIPTION
Deploys a public dns zone in azure

### RESOURCES
azurerm_resource_group.group
    azurerm_dns_zone.zone
        azurerm_dns_a_record.a
        azurerm_dns_aaaa_record.aaaa
        azurerm_dns_caa_record.caa
        azurerm_dns_cname_record.cname
        azurerm_dns_mx_record.mx
        azurerm_dns_ns_record.ns
        azurerm_dns_ptr_record.ptr
        azurerm_dns_srv_record.srv
        azurerm_dns_txt_record.txt

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

caa_record
    type: list(object)

cname_record
    type: list(object)

mx_record
    type: list(object)

ns_record
    type: list(object)

ptr_record
    type: list(object)

srv_record
    type: list(object)
    
txt_record
    type: list(object)





