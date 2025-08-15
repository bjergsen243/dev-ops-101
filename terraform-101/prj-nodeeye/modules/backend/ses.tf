# SES configuration

# resource configuration
resource "aws_ses_domain_identity" "ses" {
  domain = lookup(var.acm, "prod.domain_name")
}

resource "aws_ses_domain_identity_verification" "ses_verification" {
  domain = aws_ses_domain_identity.ses.id

  depends_on = [aws_route53_record.ses_verification_record]
}

resource "aws_ses_domain_dkim" "ses_dkim" {
  domain = aws_ses_domain_identity.ses.domain
}
