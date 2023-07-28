# Working with certificates in Azure Key Vault

A collection of scripts and documentation for managing X509 certificates in Azure key vault.

## Certificate lifecycle

The certificate lifecycle consists of three stages

1. Acquire
1. Provision
1. Renew

## Acquiring certificates

The way you acquire a certificate depends on the type of certificate authority, CA, you are working with.

For our purposes, there are four types of CAs.

1. Microsoft partner CAs
1. Public CAs (no ACME support)
1. ACME compatible CAs
1. Private CAs (no ACME support)

## What is a Microsoft partner CA?

Microsoft has partnered with GlobalSign and Digicert to automatically manage certificates in the Azure Key Vault.

If you can use the partner CAs, your life will be much easier.

[MS Docs - How to integrate CAs](https://learn.microsoft.com/azure/key-vault/certificates/how-to-integrate-certificate-authority)

## What is this `ACME` thing?

ACME is the [Automatic Certificate Management Environment](https://datatracker.ietf.org/doc/html/rfc8555) protocol.

The ACME protocol is what allows the [Let's Encrypt CA](https://letsencrypt.org/getting-started/), automatically issue certificates.

### Importing a PFX/P12

A common way public and private CAs issue certificates is with a PKCS12 formatted file.

PKCS12 is a standard file format that holds an encrypted certificate and its private key.  
A password is required to decrypt and extract the contents of the file.

```powershell
az keyvault certificate import --file --password --name --vault-name
```

### Certificate Signing Request

[MS Docs - Certificate Creation Methods](https://learn.microsoft.com/en-us/azure/key-vault/certificates/create-certificate)

The process looks like this:
[![CSR Process](https://learn.microsoft.com/en-us/azure/key-vault/media/certificate-authority-1.png)](https://learn.microsoft.com/en-us/azure/key-vault/certificates/create-certificate)

