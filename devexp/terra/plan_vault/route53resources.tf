resource "aws_route53_record" "elbstalk" {
  zone_id = "Z0909442AOAL213NZWY3"
  name    = "ebs3.devexp.gq"
  type    = "A"

  alias {
    name                   = aws_elastic_beanstalk_application_version.default.load_balancers.dns_name
    zone_id                = aws_elastic_beanstalk_application_version.default.load_balancers.zone_id
    evaluate_target_health = true
  }
}