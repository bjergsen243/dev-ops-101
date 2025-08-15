terraform {
  required_providers {
    aws = {
      configuration_aliases = []
    }
  }
}

variable "common" {}
variable "acm" {}
variable "basic_auth" {}