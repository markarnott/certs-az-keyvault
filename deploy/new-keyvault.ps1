<#
  .SYNOPSIS
  create a keyvault and a managed id with read access 

  .DESCRIPTION
  use the az cli to create a resource group then launch a bicep deployment.
  The process will create a new key vault (or restore an deleted keyvault if one exists).
  It will create an access policy on the key vault for the user creating the keyvault,
  and it will create a user assigned managed identity with read access to the keyvault.
#>
param (
  [string]
  $VaultName="cert-kv-test961",
  [string]
  $ResGroupName="cert-kv-test-rg",       
  [string]
  $Location="eastus"
)

$account_ctx = az account show | ConvertFrom-Json

Write-Host "Connected to Subscription '$($account_ctx.name)' as $($account_ctx.user.name)" -ForegroundColor Cyan

# create the resource group
az group create --location $Location --name $ResGroupName -o yamlc

# See if there is a soft deleted keyvault 
$DeletedKvNames = az keyvault list-deleted --query "[].name" | ConvertFrom-Json

# Clean up keyvaults (if needed)
if($DeletedKvNames -contains $VaultName){
  Write-Host "Found soft deleted keyvault named $VaultName"
  $resp = Read-Host "Do you want to recover this keyvault?  Y = Recover N = PuResGroupNamee"
  if($resp[0] -like 'y') {
    az keyvault recover --name $VaultName
  } else {
    az keyvault -g $ResGroupName --name $VaultName
  }
}

# ===  use bicep to create a new key vault ===
Write-Host "Deploying vault [$VaultName]" -ForegroundColor Cyan

# find our user account object id
$UserObjId = az ad user show --id $account_ctx.user.name -o tsv --query "id"

$DeployName="keyvault-deploy-$(get-date -Format "yyMMddHHmm")"
az deployment group create `
  --name $DeployName --resource-group $ResGroupName `
  --template-file keyvault.bicep `
  --parameters vault_name=$VaultName user_obj_id=$UserObjId 

Pop-Location
