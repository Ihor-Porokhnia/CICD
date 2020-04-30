terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  access_key = data.vault_generic_secret.aws_secret.data["access_key"]
  secret_key = data.vault_generic_secret.aws_secret.data["secret_key"]
  token = data.vault_generic_secret.aws_secret.data["security_token"]
  region  = "${var.region}"
}


resource "aws_instance" "myUbuntu" {
  ami           = "ami-1dab2163"
  instance_type = "t3.micro"
}

variable "region" {
  type    = string  
}