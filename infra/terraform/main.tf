terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
module "network" {
  source = "./network"

  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
}
module "security_group" {
  source = "./security_group"

  vpc_id       = module.network.vpc_id
  project_name = var.project_name
  admin_cidr   = "197.211.59.81/32"
}
module "compute" {
  source = "./compute"

  project_name      = var.project_name
  instance_type     = "t3.small"
  security_group_id = module.security_group.security_group_id

  subnet_ids = [
    module.network.public_subnet_a_id,
    module.network.public_subnet_b_id,
    module.network.public_subnet_c_id,
  ]
}
