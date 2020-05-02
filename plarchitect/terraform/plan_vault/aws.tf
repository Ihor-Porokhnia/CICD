terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  access_key = data.vault_generic_secret.aws_secret.data["access_key"]
  secret_key = data.vault_generic_secret.aws_secret.data["secret_key"]
  token      = data.vault_generic_secret.aws_secret.data["security_token"]
  region     = var.region
}


resource "aws_instance" "myUbuntu" {
  ami           = var.inst_ami
  instance_type = var.inst_type
  subnet_id     = aws_subnet.external_subnet.id
}

variable "region" {
  type = string
}
variable "inst_ami" {
  type = string
  default = "ami-0323c3dd2da7fb37d"
}
variable "inst_type" {
  type = string
  default = "t2.micro"
}

