data "aws_route53_zone" "basic_domain_name" {
  name          = lookup(var.common, "prod.domain_name")
}
