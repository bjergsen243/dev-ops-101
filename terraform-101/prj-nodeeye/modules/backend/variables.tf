terraform {
  required_providers {
    aws = {
      configuration_aliases = []
    }
  }
}

variable "common" {}
variable "rds" {}
variable "ecs" {}
variable "acm" {}
# variable "ses" {}
locals {
  subnets = cidrsubnets("10.0.0.0/16", 8, 8, 8, 8)
}
# variable "dynamodb" {}
