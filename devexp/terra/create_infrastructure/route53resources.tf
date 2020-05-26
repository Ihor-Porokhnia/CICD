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

