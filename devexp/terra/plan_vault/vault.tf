provider "vault" {
 address = "${var.vault_addr}"
 token = "${var.vault_token}"
}
variable "vault_addr" {
  type    = string  
}
variable "vault_token" {
  type    = string  
}