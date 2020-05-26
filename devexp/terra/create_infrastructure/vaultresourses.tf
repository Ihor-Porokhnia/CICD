/*
This is Vault resources file.
4 using in pipeline VAULT_TOKEN and VAULT_ADDRESS need to be exported to env vars.
*/
provider "vault" {}

data "vault_aws_access_credentials" "aws_secret" {
 backend = var.secret_backend
 role = var.secret_role
}

resource "vault_generic_secret" "api_params" {
  path = var.conf_path_vault

  data_json = jsonencode({
    "url" = "${aws_api_gateway_stage.dev_stage.invoke_url}/${aws_api_gateway_resource.resource.path_part}"
    "token" = aws_api_gateway_api_key.remo.value
  })
}

