targetScope = 'managementGroup'
param targetMG string 
var mgScope = tenantResourceId('Microsoft.Management/managementGroups', targetMG)
resource policyDefinition1 'Microsoft.Authorization/policyDefinitions@2020-03-01' = {
  name: 'Enforce purpose tag'
  properties: {
    policyType: 'Custom'
    mode: 'Indexed'
    metadata: {
      category: 'tags'
    }
    parameters: {}
    policyRule: {
     if: {
        field: 'tags[purpose]'
        exists: 'false'
      }
      then: {
        effect: 'deny'
      }
     }
    }
  }
resource policyDefinition2 'Microsoft.Authorization/policyDefinitions@2020-03-01' = {
  name: 'Enforce creator tag'
  properties: {
    policyType: 'Custom'
      mode: 'Indexed'
      metadata: {
        category: 'tags'
      }
      policyRule: {
        if: {
          allOf: [
            {
              field: 'tags[Created By]'
              exists: 'false'
            }
            {
              field: 'tags[CreatedBy]'
              exists: 'false'
            }
            {
              field: 'tags[Creator]'
              exists: 'false'
            }
          ]
        }
        then: {
          effect: 'deny'
        }
      }
      parameters: {}
    }
}
resource policyDefinition3 'Microsoft.Authorization/policyDefinitions@2020-03-01' = {
  name: 'Enforce created tag'
  properties: {
    policyType: 'Custom'
      mode: 'Indexed'
      metadata: {
        category: 'tags'
      }
      policyRule: {
        if: {
          allOf: [
            {
              field: 'tags[Created on]'
              exists: 'false'
            }
            {
              field: 'tags[Createdon]'
              exists: 'false'
            }
            {
              field: 'tags[Created]'
              exists: 'false'
            }
          ]
        }
        then: {
          effect: 'append'
          details: [
            {
              field: 'tags[created]'
              value: '[utcNow()]'
            }
          ]
        }
      }
      parameters: {}
    }
}
resource policySetDefinition 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: 'name'
  properties: {
    displayName: 'Enforce tags'
    policyType: 'Custom'
    description: 'description'
    metadata: {
      version: '0.1.0'
      category: 'tags'
      source: 'source'
    }
    policyDefinitions: [
      {
        policyDefinitionId: extensionResourceId(mgScope, 'Microsoft.Authorization/policyDefinitions', policyDefinition1.name)
      }
      {
        policyDefinitionId: extensionResourceId(mgScope, 'Microsoft.Authorization/policyDefinitions', policyDefinition2.name)
      }
      {
        policyDefinitionId: extensionResourceId(mgScope, 'Microsoft.Authorization/policyDefinitions', policyDefinition3.name)
      }
    ]
  }
}
resource PolicyAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'enforce tags'
  properties: {
    scope: mgScope
    description: 'enforce tags'
    displayName: 'enforce tags'
    enforcementMode: 'default'
    nonComplianceMessages: [
      {
        message: 'Required tags: purpose and creator'
      }
    ]
//can change subscription id or remove it completely if not used    
    notScopes: [
      '/subscriptions/16b8a2be-b437-4772-95b8-2996bef4ac2a'
    ]
    policyDefinitionId: extensionResourceId(mgScope, 'Microsoft.Authorization/PolicySetDefinitions', policySetDefinition.name)
  }
}
