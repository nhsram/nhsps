targetScope = 'managementGroup'
var policyName = 'audit-resource-tag-and-value-format-pd'
var policyDisplayName = 'Audit a tag and its value format on resources'
var policyDescription = 'Audits existence of a tag and its value format. Does not apply to resource groups.'

resource policy 'Microsoft.Authorization/policyDefinitions@2021-09-22' = {
  name: policyName
  properties: {
    displayName: policyDisplayName
    description: policyDescription
    policyType: 'Custom'
    mode: 'Indexed'
    metadata: {
      category: 'Tags'
    }

    parameters: {
      tagName: {
        type: 'String'
        metadata: {
          displayName: 'Tag name'
          description: 'A tag to audit'
        }
      }
      tagFormat: {
        type: 'String'
        metadata: {
          displayName: 'Tag format'
          description: 'An expressions for \'like\' condition' // Use backslash as an escape character for single quotation marks
        }
      }
    }

    policyRule: {
      if: {
        field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]' // No need to use an additional forward square bracket in the expressions as in ARM templates
        notLike: '[parameters(\'tagFormat\')]'
      }
      then: {
        effect: 'Audit'
      }
    }
  }
}
