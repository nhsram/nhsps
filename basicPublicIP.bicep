param publicIpName string = 'Test Public IP'
module publicIp './publicIP.bicep' = {
  name: 'publicIp'
  params: {
    publicIpResourceName: publicIpName
    dynamicAllocation: true    
  }
}
// To reference module outputs
output ipFqdn string = publicIp.outputs.ipFqdn
