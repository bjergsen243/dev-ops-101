resource "aws_acm_certificate" "fronend_cert" {
  domain_name               = lookup(var.acm, "prod.domain_name")
  subject_alternative_names = ["*.${lookup(var.acm, "prod.domain_name")}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "ACM for frontend subdomain"
  }
}
