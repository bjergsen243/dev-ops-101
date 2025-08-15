resource "aws_lambda_function" "docker_lambda" {
  function_name    = "create-thumbnail-s3-${lower(terraform.workspace)}"
  role             = aws_iam_role.lambda_role.arn
#  runtime          = "provided"
  package_type     = "Image"
  timeout          = 900
  memory_size      = 2048
  image_uri        = "${aws_ecr_repository.lambda.repository_url}:latest"
}

resource "aws_lambda_permission" "allow_terraform_bucket" {
  statement_id = "AllowExecutionFromS3Bucket"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.docker_lambda.arn
  principal = "s3.amazonaws.com"
  source_arn = "arn:aws:s3:::${lower(lookup(var.common, "${terraform.workspace}.profile"))}-main"
}

resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = "${lower(lookup(var.common, "${terraform.workspace}.profile"))}-main"

  lambda_function {
    lambda_function_arn = aws_lambda_function.docker_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "assets/"
  }
  depends_on = [aws_lambda_permission.allow_terraform_bucket]
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_full_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_s3_full_cloudwatch" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_ecr_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
