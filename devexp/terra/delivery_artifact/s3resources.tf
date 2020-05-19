/*
This plan used 2 create S3 bucket and upload artifacts
*/
/* resource "aws_s3_bucket" "backend_S3_bucket" {
  bucket = "${var.project_name}--bucket"
  acl    = "private"
  region = var.region  
} */

resource "aws_s3_bucket_object" "artifact" {
  key        = "${var.upload_s3_prefix}/${var.artifact_name}"
  bucket     = "${var.project_name}--bucket"
  source     = "${var.local_path}/${var.artifact_name}"
  etag       = filemd5("${var.local_path}/${var.artifact_name}")
  
}


variable "artifact_name" {
  type    = string  
}
variable "local_path" {
  type    = string  
}
variable "upload_s3_prefix" {
  type = string
}