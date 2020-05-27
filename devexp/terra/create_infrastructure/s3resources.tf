/*
This plan used 2 create S3 bucket and upload artifacts
*/

locals {
  public_dir_with_leading_slash = "${length(var.public_dir) > 0 ? "/${var.public_dir}" : ""}"
  static_website_routing_rules = jsonencode([{
    "Condition" = {
        "KeyPrefixEquals" = "${var.public_dir}/${var.public_dir}/"
    },
    "Redirect" = {
        "Protocol" = "https",
        "HostName" = var.domain_name,
        "ReplaceKeyPrefixWith" = "",
        "HttpRedirectCode" = "301"
    }
}])
}


resource "aws_s3_bucket" "static_website" {
  bucket = var.domain_name
  force_destroy = true
  website {
    index_document = "index.html"
    error_document = "error.html"
    routing_rules = local.static_website_routing_rules
  }
  tags = map("Name", "${var.domain_name}-static_website")
}

