terraform {
  # required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.70.0"
    }
  }
  backend "s3" {
    profile                 = "DIGITORI360-Prod"
    region                  = "ap-northeast-1"
    bucket                  = "digitori360-prod-tfstate"
    key                     = "mystate.tfstate"
    encrypt                 = true
    shared_credentials_file = "~/.aws/credentials"
  }
}

variable "common" {}
variable "acm" {}
variable "rds" {}
variable "ecs" {}
variable "basic_auth" {}
