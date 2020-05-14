resource "aws_route53_record" "elbstalk" {
  zone_id = "Z0909442AOAL213NZWY3"
  name    = "ebs3.devexp.gq"
  type    = "A"

  alias {
    name                   = aws_elastic_beanstalk_environment.api.cname
    zone_id                = data.aws_elastic_beanstalk_hosted_zone.current.id
    evaluate_target_health = true
  }
} 
data "aws_elastic_beanstalk_hosted_zone" "current" {}