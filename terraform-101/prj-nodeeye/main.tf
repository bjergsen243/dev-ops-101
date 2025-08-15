module "auth" {
  source = "./modules/auth"
  common = var.common

  providers = {}
}

module "backend" {
  source = "./modules/backend"
  common = var.common
  ecs    = var.ecs
  acm    = var.acm
  rds    = var.rds
  #   slack                = var.slack
  #   ses                  = var.ses
  #   dynamodb             = var.dynamodb

  providers = {}
}

module "frontend" {
  source           = "./modules/frontend"
  common           = var.common
  acm              = var.acm
  basic_auth       = var.basic_auth
  # slack            = var.slack
  providers = {
    aws = aws.virginia
  }
}

module "storage" {
  source = "./modules/storage"
  common = var.common

  providers = {}
}
