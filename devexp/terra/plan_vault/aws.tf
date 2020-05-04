terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  access_key = data.vault_generic_secret.aws_secret.data["access_key"]
  secret_key = data.vault_generic_secret.aws_secret.data["secret_key"]
  token = data.vault_generic_secret.aws_secret.data["security_token"]
  region  = var.region
}

resource "aws_s3_bucket" "backend_S3_bucket" {
  bucket = "backends3bucket05"
  acl    = "private"
  provisioner "local-exec" {
    command = "ls -lah"
  }
}

resource "aws_s3_bucket_object" "examplebucket_object" {
  key        = "tertertert"
  bucket     = aws_s3_bucket.backend_S3_bucket.id
  source     = "tertertert"  
}


variable "region" {
  type    = string  
}
