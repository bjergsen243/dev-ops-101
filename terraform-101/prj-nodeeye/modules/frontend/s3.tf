resource "aws_s3_bucket" "website_hosting_frontend_web" {
  bucket = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-frontend-web"

  tags = {
    Name        = "${lower(lookup(var.common, "customer"))}-${lower(terraform.workspace)}-frontend-web"
  }
}

resource "aws_s3_bucket_ownership_controls" "website_hosting_frontend_web" {
  bucket = aws_s3_bucket.website_hosting_frontend_web.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "website_hosting_frontend_web" {
  depends_on = [aws_s3_bucket_ownership_controls.website_hosting_frontend_web]
  bucket = aws_s3_bucket.website_hosting_frontend_web.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "website_hosting_frontend_web" {
  bucket = aws_s3_bucket.website_hosting_frontend_web.id
  policy = data.aws_iam_policy_document.website_hosting_frontend_web.json
}

data "aws_iam_policy_document" "website_hosting_frontend_web" {
  statement {
    sid     = "RestrictBucketAccess"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    resources = [
      "${aws_s3_bucket.website_hosting_frontend_web.arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oid_frontend_web.iam_arn]
    }
  }
}
