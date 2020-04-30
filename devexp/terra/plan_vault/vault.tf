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

variable "region" {
  type    = string  
}
data "vault_aws_access_credentials" "creds" {
  backend = "amazon01"
  role    = "terraformer"
}


provider "aws" {
  access_key = "${data.vault_aws_access_credentials.creds.access_key}"
  secret_key = "${data.vault_aws_access_credentials.creds.secret_key}"
  region  = "${var.region}"
}