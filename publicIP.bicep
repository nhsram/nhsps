param publicIpResourceName string
param publicIpDnsLabel string = '${publicIpResourceName}-${newGuid()}'
param location string = resourceGroup().location
param dynamicAllocation bool

resource publicIp 'Microsoft.Network/publicIPAddresses@2021-09-23' = {
  name: publicIpResourceName
  location: location
  properties: {
    publicIPAllocationMethod: dynamicAllocation ? 'Dynamic' : 'Static'
    dnsSettings: {
      domainNameLabel: publicIpDnsLabel
    }
  }
}

// Set an output which can be accessed by the module consumer
output ipFqdn string = publicIp.properties.dnsSettings.fqdn
