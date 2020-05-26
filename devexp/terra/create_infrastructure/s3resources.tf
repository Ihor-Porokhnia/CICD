/*
This plan used 2 create S3 bucket and upload artifacts
*/
resource "aws_s3_bucket" "backend_S3_bucket" {
  bucket = "${var.project_name}--bucket"
  acl    = "private"
  region = var.region
  force_destroy = true  
}
module "s3-static-website" {
  source  = "conortm/s3-static-website/aws"
  domain_name = var.root_domain
  redirects   = [var.redirect_domain]
  secret      = var.project_name
  cert_arn    = var.ssl2_cert_arn
  zone_id     = var.zone_id
  
}