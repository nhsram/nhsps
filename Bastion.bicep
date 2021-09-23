param virtualNetworkName string = 'testvnet'
param vNetIpPrefix string = '10.1.0.0/16'
param bastionSubnetIpPrefix string = '10.1.1.0/27'
param bastionHostName string
param location string = resourceGroup().location

resource publicIp 'Microsoft.Network/publicIPAddresses@2021-09-22' = {
  name: '${bastionHostName}-pip'
  location: location
  sku: {  name: 'Standard' }
  properties: {    publicIPAllocationMethod: 'Static'  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-09-22' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNetIpPrefix
      ]
    }
  }
}

resource subNet 'Microsoft.Network/virtualNetworks/subnets@2021-09-22' = {
  name: '${virtualNetwork.name}/AzureBastionSubnet'
  properties: {
    addressPrefix: bastionSubnetIpPrefix
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2021-09-22' = {
  name: bastionHostName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: subNet.id
          }
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
  }
}
