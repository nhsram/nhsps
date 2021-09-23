targetScope = 'subscription'
param principalId string
var roleName = 'Test Bicep Custom Role'

resource definition 'Microsoft.Authorization/roleDefinitions@2021-09-22-preview' = {
  name: guid(roleName)
  properties: {
    roleName: roleName
    description: 'Create a Custom role with Bicep'
    permissions: [
      {
        actions: [
          '*/read'
        ]
      }
    ]
    assignableScopes: [
      subscription().id
    ]
  }
}

resource assignment 'Microsoft.Authorization/roleAssignments@2021-09-22-preview' = {
  name: guid(roleName, principalId, subscription().subscriptionId)
  properties: {
    roleDefinitionId: definition.id
    principalId: principalId
  }
}
