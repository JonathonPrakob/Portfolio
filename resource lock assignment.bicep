resource applicationSecurityGroup 'Microsoft.Network/applicationSecurityGroups@2020-11-01' = {
  name: 'name'
  location: 'east us'
}
resource asgLock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: 'Delete lock'
  scope: applicationSecurityGroup
  properties: {
    level: 'CanNotDelete'
  }
}
