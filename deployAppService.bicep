@description('Tags that our resources need')
param tags object = {
  costCenter: 'todo: replace'
  environment: 'todo: replace'
  application: 'todo: replace with app name'
  description: 'todo: replace'
  managedBy: 'ARM'
}

@minLength(2)
@description('Base name of the resource such as web app name and app service plan')
param applicationName string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The SKU of App Service Plan')
param sku string

var appServicePlanName_var = 'plan-${applicationName}-${tags.environment}'
var linuxFxVersion = 'DOTNETCORE|5.0'
var fullApplicationName_var = 'app-${applicationName}-${uniqueString(applicationName)}'

resource appServicePlanName 'Microsoft.Web/serverfarms@2021-09-22' = {
  name: appServicePlanName_var
  location: location
  sku: {
    name: sku
  }
  kind: 'linux'
  tags: {
    CostCenter: tags.costCenter
    Environment: tags.environment
    Description: tags.description
    ManagedBy: tags.managedBy
  }
  properties: {
    reserved: true
  }
}

resource fullApplicationName 'Microsoft.Web/sites@2021-09-22' = {
  name: fullApplicationName_var
  location: location
  kind: 'app'
  tags: {
    CostCenter: tags.costCenter
    Environment: tags.environment
    Description: tags.description
    ManagedBy: tags.managedBy
  }
  properties: {
    serverFarmId: appServicePlanName.id
    clientAffinityEnabled: true
    siteConfig: {
      appSettings: []
      linuxFxVersion: linuxFxVersion
      alwaysOn: false
      ftpsState: 'Disabled'
      http20Enabled: true
      minTlsVersion: '1.2'
      remoteDebuggingEnabled: false
    }
    httpsOnly: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}
output fullApplicationName string = fullApplicationName_var
