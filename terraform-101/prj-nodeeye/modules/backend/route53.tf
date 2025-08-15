data "aws_route53_zone" "basic_domain_name" {
  name          = lookup(var.acm, "prod.domain_name")
}

resource "aws_route53_record" "api" {
  zone_id         = data.aws_route53_zone.basic_domain_name.zone_id
  name            = "api"
  type            = "A"
  allow_overwrite = "true"

  alias {
    name                   = aws_lb.main_alb.dns_name
    zone_id                = aws_lb.main_alb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "ses_verification_record" {
  name            = "_amazonses"
  type            = "TXT"
  zone_id         = data.aws_route53_zone.basic_domain_name.zone_id
  records         = [aws_ses_domain_identity.ses.verification_token]
  ttl             = 600
  allow_overwrite = "true"
}

# SES DKIM Record
resource "aws_route53_record" "ses_verification_dkim_record" {
  count   = 3
  name    = "${element(aws_ses_domain_dkim.ses_dkim.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  zone_id = data.aws_route53_zone.basic_domain_name.zone_id
  records = ["${element(aws_ses_domain_dkim.ses_dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
  ttl     = 600
}
