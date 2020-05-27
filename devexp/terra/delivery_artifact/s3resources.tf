/*
This plan used 2 create S3 bucket and upload artifacts
*/


resource "aws_s3_bucket_object" "artifact" {
  key        = "${var.upload_s3_prefix}/${var.artifact_name}"
  bucket     = var.domain_name
  source     = "${var.local_path}/${var.artifact_name}"
  etag       = filemd5("${var.local_path}/${var.artifact_name}")  
}


