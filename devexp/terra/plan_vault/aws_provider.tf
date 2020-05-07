terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  access_key = data.vault_aws_access_credentials.aws_secret.access_key
  secret_key = data.vault_aws_access_credentials.aws_secret.secret_key
  token      = data.vault_aws_access_credentials.aws_secret.security_token
  region     = var.region
}
variable "project_name" {
  type    = string  
}