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

resource "aws_elastic_beanstalk_application" "beanapp" {
  name        = "tf-test-name"
  description = "tf-test-desc"
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = "tf-test-version-label"
  application = "tf-test-name"
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.backend_S3_bucket.id
  key         = aws_s3_bucket_object.artifact.id
}
resource "aws_elastic_beanstalk_environment" "tfenvtest" {
  name                = "tf-test-name"
  application         = aws_elastic_beanstalk_application.beanapp.name
  solution_stack_name = "64bit Amazon Linux 2 v3.0.0 running Corretto 11"
}
variable "region" {
  type    = string  
}
