<#
    .SYNOPSIS
    Use the AZ CLI to generate a CSR, certificate signing request, from an Azure Key Vault.
#>
Function New-CsrFromKeyVault {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $VaultName,
        [Parameter(Mandatory = $true, ParameterSetName = "Policy")]
        [string]
        $Policy,
        [Parameter(Mandatory = $true, ParameterSetName = "DnsName")]
        [string]
        $DnsName,        
        [Parameter(Mandatory)]
        [string]
        $CertName
    )

    if($CertName -eq "") { $CertName = get-date -Format "yyMMdd-HHmm" }

    if($Policy -eq "") {
        $Policy = @"
{ \"issuer\": { \"name\": \"Unknown\" }, \"x509_props\": { \"subject\": \"cn=$DnsName\" } }
"@
    }

    Write-Verbose "$Policy"
    az keyvault certificate create --name $CertName --vault-name $VaultName --policy "$Policy"

    $csr = az keyvault certificate pending show --name $CertName --vault-name $VaultName -o tsv --query csr

    return "-----BEGIN CERTIFICATE REQUEST-----`n$csr`n-----END CERTIFICATE REQUEST-----"
}