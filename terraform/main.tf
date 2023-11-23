terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.23.1"
    }
  }
}


provider "aws" {
  region = "eu-west-1"
}

module "infrastructure" {
  source = "./infrastructure"
}

# module "juiceshop" {
#   source = "./juiceshop"
#   fwsshkey           = module.infrastructure.fwsshkey
#   customer_vpc_id    = module.infrastructure.customer_vpc_id
#   csprivatesubnetaz1 = module.infrastructure.csprivatesubnetaz1
#   depends_on = [ module.infrastructure]
# }
