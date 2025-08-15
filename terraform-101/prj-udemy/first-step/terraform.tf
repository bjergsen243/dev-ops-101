// Change your region

// Create this bucket on S3 and table on DynamoDB by yourself
terraform {
  backend "s3" {
    bucket = "terraform-state-udemy"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-locking"
  }
}

provider "aws" {
  region = "us-east-1"
}