resource "aws_cloudfront_distribution" "cloudfront_frontend_web" {
  origin {
    domain_name = aws_s3_bucket.website_hosting_frontend_web.bucket_domain_name
    origin_id   = "origin-s3-frontend-web-${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oid_frontend_web.cloudfront_access_identity_path
    }
  }

  is_ipv6_enabled     = true
  enabled             = true
  comment             = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-web"
  default_root_object = "index.html"

  aliases = [
    lookup(var.acm, "prod.domain_name"),
    "www.${lookup(var.acm, "prod.domain_name")}",
  ]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.fronend_cert.arn
    cloudfront_default_certificate = false
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.1_2016"
  }

  default_cache_behavior {
    target_origin_id       = "origin-s3-frontend-web-${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    min_ttl     = 0
    default_ttl = 1800
    max_ttl     = 1800

    smooth_streaming = false

    forwarded_values {
      headers      = ["Authorization"]
      query_string = false

      cookies {
        forward = "none"
      }
    }

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.basic_auth.arn
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "oid_frontend_web" {
  comment = "access-identity restrict s3 bucket access for frontend_web"
}

resource "aws_cloudfront_function" "basic_auth" {
  name    = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-basic-auth"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = templatefile(
    "./basic-auth.js",
    {
        basic_auth_username = lookup(var.basic_auth, "username")
        basic_auth_password = lookup(var.basic_auth, "password")
    }
  )
}
