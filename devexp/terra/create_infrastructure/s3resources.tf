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
resource "aws_s3_bucket_object" "lorem_page" {
  bucket = aws_s3_bucket.static_website.id
  key    = "${var.public_dir}/index.html"
  content = <<EOF
  <!DOCTYPE html>
<html>
<head>
    <title>Index.html</title>    
</head>
<body>
    <h1>Created by terraform</h1>
</body>
</html>
  EOF
}
