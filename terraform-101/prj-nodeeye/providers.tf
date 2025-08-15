provider "aws" {
  profile = lookup(var.common, "${terraform.workspace}.profile", var.common["default.profile"])
  region  = lookup(var.common, "${terraform.workspace}.region", var.common["default.region"])
}

provider "aws" {
  alias   = "virginia"
  profile = lookup(var.common, "${terraform.workspace}.profile", var.common["default.profile"])
  region  = "us-east-1"
}

# provider "awscc" {
#   profile = local.profile
#   region  = lookup(local.env, "region")
# }


