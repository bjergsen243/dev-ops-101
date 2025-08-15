data "aws_iam_policy_document" "s3" {
  statement {
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [ "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" ]
    }
    actions = [ 
      "s3:GetObject",
      "s3:Get*",
      "s3:List*",
     ]
     resources = [ 
      "${aws_s3_bucket.s3.arn}/*",
      ]
  }
}