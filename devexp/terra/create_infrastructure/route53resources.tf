resource "aws_route53_record" "elbstalk" {
  zone_id = var.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = aws_elastic_beanstalk_environment.api.cname
    zone_id                = data.aws_elastic_beanstalk_hosted_zone.current.id
    evaluate_target_health = true
  }
} 
data "aws_elastic_beanstalk_hosted_zone" "current" {}

resource "aws_route53_record" "alias" {
  count = length(var.zone_id) > 0 ? 1 : 0

  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                    = aws_cloudfront_distribution.cdn.domain_name
    zone_id                 = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health  = false
  }
}