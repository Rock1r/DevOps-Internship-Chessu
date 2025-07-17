module "network" {
  source             = "./modules/network"
}

module "endpoints" {
  source = "./modules/endpoints"

  vpc_id             = module.network.vpc_id
  security_group_ids = [module.security.ecr_endpoint_security_group_id]
  private_subnets    = module.network.private_subnet_ids
  vpc_private_route_table_ids = module.network.vpc_private_route_table_ids

}

module "security" {
  source   = "./modules/security"
  vpc_id   = module.network.vpc_id
  vpc_cidr = module.network.vpc_cidr_block
}