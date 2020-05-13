resource "aws_route53_record" "elbstalk" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "ebs3.devexp.gq"
  type    = "A"

  alias {
    name                   = aws_elastic_beanstalk_application_version.default.load_balancers[1].dns_name
    zone_id                = aws_elastic_beanstalk_application_version.default.load_balancers[1].zone_id
    evaluate_target_health = true
  }
}