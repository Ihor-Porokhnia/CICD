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
  region = var.region  
}

resource "aws_s3_bucket_object" "artifact" {
  key        = "artifacts01/ssl-test-jenkins-EBS-48.zip"
  bucket     = aws_s3_bucket.backend_S3_bucket.id
  source     = "ssl-test-jenkins-EBS-48.zip"  
}



variable "region" {
  type    = string  
}
