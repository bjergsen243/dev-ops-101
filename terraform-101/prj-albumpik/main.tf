module "backend" {
  source = "./modules/backend"
  common = var.common
  rds    = var.rds
  providers = {

  }
}

module "storage" {
  source = "./modules/storage"
  common = var.common

  providers = {

  }
}

module "frontend" {
  source = "./modules/frontend"
  common = var.common
  providers = {

  }
}