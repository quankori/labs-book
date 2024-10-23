resource "aws_route53_zone" "prj_r53_hz_dev" {
  name          = var.project_domain
  comment       = "Project testing hostzone"
  force_destroy = false
  tags = {
    Name = "${var.project_name}-r53-hz-${var.project_env}"
  }
}



resource "aws_route53_record" "prj_front_rc" {
  zone_id = aws_route53_zone.prj_r53_hz_dev.zone_id
  name    = var.project_domain
  type    = "A"
  alias {
    zone_id                = "Z2FDTNDATAQYW2"
    name                   = aws_cloudfront_distribution.prj_cloudfront_fe_dev.domain_name
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "prj_front_www_rc" {
  zone_id = aws_route53_zone.prj_r53_hz_dev.zone_id
  name    = "www.${var.project_domain}"
  type    = "CNAME"
  ttl     = 300
  records = ["${aws_cloudfront_distribution.prj_cloudfront_fe_dev.domain_name}"]
}


resource "aws_route53_record" "prj_cert_rc" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.prj_acm_dev.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.prj_acm_dev.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.prj_acm_dev.domain_validation_options)[0].resource_record_type
  zone_id         = aws_route53_zone.prj_r53_hz_dev.id
  ttl             = 60
}

resource "aws_route53_record" "prj_api_rc" {
  zone_id = aws_route53_zone.prj_r53_hz_dev.zone_id
  name    = "api.${var.project_domain}"
  type    = "CNAME"
  ttl     = 300
  records = ["${aws_cloudfront_distribution.prj_cloudfront_api_dev.domain_name}"]
}
