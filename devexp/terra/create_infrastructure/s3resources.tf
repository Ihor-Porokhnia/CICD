/*
This plan used 2 create S3 bucket and upload artifacts
*/
resource "aws_s3_bucket" "backend_S3_bucket" {
  bucket = "${var.project_name}--bucket"
  acl    = "private"
  region = var.region
  force_destroy = true  
}
/* module "s3-static-website" {
  source  = "conortm/s3-static-website/aws"
  domain_name = var.root_domain
  //redirects   = [var.redirect_domain]
  secret      = var.project_name
  cert_arn    = var.ssl2_cert_arn
  zone_id     = var.zone_id
  
} */
locals {
  public_dir_with_leading_slash = "${length(var.public_dir) > 0 ? "/${var.public_dir}" : ""}"
  static_website_routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "${var.public_dir}/${var.public_dir}/"
    },
    "Redirect": {
        "Protocol": "https",
        "HostName": "${var.domain_name}",
        "ReplaceKeyPrefixWith": "",
        "HttpRedirectCode": "301"
    }
}]
EOF
  
/*   jsonencode({
    "Condition" = {
        "KeyPrefixEquals" = "${var.public_dir}/${var.public_dir}/"
    },
    "Redirect" = {
        "Protocol" = "https",
        "HostName" = var.domain_name,
        "ReplaceKeyPrefixWith" = "",
        "HttpRedirectCode" = "301"
    }
}) */


}


resource "aws_s3_bucket" "static_website" {
  bucket = var.domain_name
  force_destroy = true
  website {
    index_document = "index.html"
    error_document = "error.html"
    routing_rules = "${length(var.public_dir) > 0 ? local.static_website_routing_rules : ""}"
  }
  tags = map("Name", "${var.domain_name}-static_website")
}

