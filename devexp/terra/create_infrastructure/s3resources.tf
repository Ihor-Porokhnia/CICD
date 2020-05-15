/*
This plan used 2 create S3 bucket and upload artifacts
*/
resource "aws_s3_bucket" "backend_S3_bucket" {
  bucket = "${var.project_name}--bucket"
  acl    = "private"
  region = var.region  
}
