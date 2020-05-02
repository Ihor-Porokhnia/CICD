provider "vault" {
 //address = var.vault_addr
 //token = var.vault_token
}

data "vault_generic_secret" "aws_secret" {
  path = var.secret_path
}

variable "vault_addr" {
  type    = string  
}
variable "vault_token" {
  type    = string  
}
variable "secret_path" {
  type    = string  
}
