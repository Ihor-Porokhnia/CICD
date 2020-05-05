provider "vault" {}

data "vault_aws_access_credentials" "aws_secret" {
 backend = var.secret_backend
 role = var.secret_role
}

variable "secret_backend" {
  type    = string  
}
variable "secret_role" {
  type    = string  
}
