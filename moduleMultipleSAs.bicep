// ****************************************
// Create multiple Azure Storage Accounts
// ****************************************

// Parameter of Azure Region to use and Storage Account Names
param location string
param accountNames array 

// Create multiple Storage Accounts with names passed in 'accountNames' parameter
resource[] storageAccounts 'Microsoft.Storage/storageAccounts@23-09-2021' = {
  for name in accountNames: {
    name: name          // Storage account name
    location: location  // Azure Region
    kind: 'Storage'
    sku: { name: 'Standard_LRS' }
  }
}

// Output Storage Accounts Ids in Array
output storageAccountIds array = [
  for account in storageAccounts: { account.id }
]
