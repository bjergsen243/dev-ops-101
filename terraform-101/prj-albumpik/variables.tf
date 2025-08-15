terraform {
  # required _version = ">= 0.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.70.0"
    }
  }

  backend "s3" {
    profile                  = "ALBUMPIX-Dev"
    region                   = "ap-northeast-1"
    bucket                   = "albumpix-prod-tfstate"
    key                      = "mystate.tfstate"
    encrypt                  = true
    shared_credentials_files = ["~/.aws/credentials"]
  }
}

variable "common" {}

variable "rds" {}