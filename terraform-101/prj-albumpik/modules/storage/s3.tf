resource "aws_s3_bucket" "s3" {
  bucket        = "${lower(lookup(var.common, "${terraform.workspace}.profile"))}-main"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "s3" {
  bucket = aws_s3_bucket.s3.bucket
}

resource "aws_s3_bucket_ownership_controls" "s3" {
  bucket = aws_s3_bucket.s3.bucket
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.s3]
}

resource "aws_s3_bucket_cors_configuration" "s3" {
  bucket = aws_s3_bucket.s3.id
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "s3" {
  bucket = aws_s3_bucket.s3.id
  policy     = data.aws_iam_policy_document.s3.json
  depends_on = [aws_s3_bucket_public_access_block.s3]
}

data "aws_caller_identity" "current" {}
