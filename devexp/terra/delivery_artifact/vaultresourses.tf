/*
This is Vault resources file.
4 using in pipeline VAULT_TOKEN and VAULT_ADDRESS need to be exported to env vars.
*/
provider "vault" {}

data "vault_aws_access_credentials" "aws_secret" {
 backend = var.secret_backend
 role = var.secret_role
}

