targetScope = 'managementGroup'
var policyName = 'audit-resource-group-tag-pd'
var policyDisplayName = 'Audit a tag on resource groups'
var policyDescription = 'Audits existence of a tag. Does not apply to individual resources.'
resource policy 'Microsoft.Authorization/policyDefinitions@2021-09-23' = {
  name: policyName
  properties: {
    displayName: policyDisplayName
    description: policyDescription
    policyType: 'Custom'
    mode: 'All'
    metadata: {
      category: 'Tags'
    }

    parameters: {
      tagName: {
        type: 'String'
        metadata: {
          displayName: 'Tag name'
          description: 'Audit Tag'
        }
      }
    }

    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Resources/subscriptions/resourceGroups'
          }
          {
            field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
            exists: false
          }
        ]
      }
      then: {
        effect: 'Audit'
      }
    }
  }
}
