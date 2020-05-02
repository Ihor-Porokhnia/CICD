provider "vault" {}

data "vault_generic_secret" "aws_secret" {
 path = var.secret_path
}

variable "secret_path" {
  type    = string  
}
