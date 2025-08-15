data "aws_route53_zone" "basic_domain_name" {
  name          = lookup(var.acm, "prod.domain_name")
}

resource "aws_route53_record" "frontend" {
  zone_id         = data.aws_route53_zone.basic_domain_name.zone_id
  name            = ""
  type            = "A"
  allow_overwrite = "true"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront_frontend_web.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_frontend_web.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id         = data.aws_route53_zone.basic_domain_name.zone_id
  name            = "www"
  type            = "A"
  allow_overwrite = "true"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront_frontend_web.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_frontend_web.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.fronend_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = data.aws_route53_zone.basic_domain_name.zone_id
  ttl             = 300
  allow_overwrite = true
}
