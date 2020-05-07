resource "aws_s3_bucket" "backend_S3_bucket" {
  bucket = "${var.project_name}--bucket"
  acl    = "private"
  region = var.region  
}

resource "aws_s3_bucket_object" "artifact" {
  key        = "${var.project_name}/${var.artifact_name}"
  bucket     = aws_s3_bucket.backend_S3_bucket.id
  source     = "${var.local_path}/${var.artifact_name}"  
}
variable "artifact_name" {
  type    = string  
}
variable "local_path" {
  type    = string  
}