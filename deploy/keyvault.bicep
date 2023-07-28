param vault_name string
param user_obj_id string
param managed_id_name string = 'keyvault_reader_id'
param location string = resourceGroup().location
param tenant_id string = tenant().tenantId

resource managed_id 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managed_id_name
  location: location
}

resource vault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: vault_name
  location: location
  properties: {
    accessPolicies:[]
    enableRbacAuthorization: false
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    enabledForDeployment: false
    tenantId: subscription().tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

resource vault_access_policy 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  name: 'add'
  parent: vault
  properties: {
    accessPolicies: [
      {
        objectId: user_obj_id
        tenantId: tenant_id
        permissions: {
          certificates: [
            'Get'
            'List'
            'Update'
            'Create'
            'Import'
            'Delete'
            'Recover'
            'Backup'
            'Restore'
            'ManageContacts'
            'ManageIssuers'
            'GetIssuers'
            'ListIssuers'
            'SetIssuers'
            'DeleteIssuers'
          ]
          secrets: [
            'Get'
            'List'
            'Set'
            'Delete'
            'Recover'
            'Backup'
            'Restore'
          ]
        }

      }
      {
        objectId: managed_id.properties.principalId
        tenantId: tenant_id
        permissions: {
          secrets: [
            'Get'
            'List'
          ]
        }
      }
    ]
  }
}


