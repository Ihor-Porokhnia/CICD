terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  access_key = data.vault_generic_secret.aws_secret.data["access_key"]
  secret_key = data.vault_generic_secret.aws_secret.data["secret_key"]
  token = data.vault_generic_secret.aws_secret.data["security_token"]
  region  = var.region
}


resource "aws_instance" "myUbuntu" {
  ami           = "ami-0323c3dd2da7fb37d"
  instance_type = "t2.micro"
}

variable "region" {
  type    = string  
}
