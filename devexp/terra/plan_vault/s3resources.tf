/*
This plan used 2 create S3 bucket and upload artifacts
*/
resource "aws_s3_bucket" "backend_S3_bucket" {
  bucket = "${var.project_name}--bucket"
  acl    = "private"
  region = var.region  
}

resource "aws_s3_bucket_object" "artifact" {
  key        = "${var.project_name}/${var.artifact_name}"
  bucket     = aws_s3_bucket.backend_S3_bucket.id
  source     = "${var.local_path}/${var.artifact_name}"
  etag       = filemd5("${var.local_path}/${var.artifact_name}")
  depends_on = [aws_s3_bucket_object.upexist]
}

data "aws_s3_bucket_objects" "existing_objects" {
  bucket = "${var.project_name}--bucket"
  prefix =  var.project_name
}

/* data "aws_s3_bucket_object" "existing_object_info" {
  count  = length(data.aws_s3_bucket_objects.existing_objects.keys)
  key    = element(data.aws_s3_bucket_objects.existing_objects.keys, count.index)  
} */
resource "aws_s3_bucket_object" "upexist" {
  count      = length(data.aws_s3_bucket_objects.existing_objects.keys)
  key        = element(data.aws_s3_bucket_objects.existing_objects.keys, count.index)
  bucket     = aws_s3_bucket.backend_S3_bucket.id
}

variable "artifact_name" {
  type    = string  
}
variable "local_path" {
  type    = string  
}