
locals {
  s3_origin_id = "cloudfront-distribution-origin-${var.domain_name}.s3.amazonaws.com${local.public_dir_with_leading_slash}"
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.static_website.bucket_regional_domain_name
    origin_path = local.public_dir_with_leading_slash
    origin_id   = local.s3_origin_id

    custom_origin_config {
      http_port               = 80
      https_port              = 443
      origin_protocol_policy  = "http-only"
      origin_ssl_protocols    = ["TLSv1.2", "TLSv1.1", "TLSv1"]
    }

    custom_header {
      name  = "User-Agent"
      value = var.project_name
    }
  }

  comment             = "CDN for ${var.domain_name} S3 Bucket"
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = ["${var.domain_name}"]

  custom_error_response {
    error_code          = 403
    response_page_path  = "/error.html"
    response_code       = 404
  }

  custom_error_response {
    error_code          = 404
    response_page_path  = "/error.html"
    response_code       = 404
  }

  default_cache_behavior {
    target_origin_id = local.s3_origin_id
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn       = var.ssl2_cert_arn
    ssl_support_method        = "sni-only"
    minimum_protocol_version  = "TLSv1.1_2016"
  }
  depends_on = [
    aws_s3_bucket.static_website,
  ]
  tags = map("Name", "${var.domain_name}-cdn")
}