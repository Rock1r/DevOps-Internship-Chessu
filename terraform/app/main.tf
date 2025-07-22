
module "alb" {
  source = "./modules/alb"

  vpc_id             = data.terraform_remote_state.network-security.outputs.vpc_id
  public_subnets     = data.terraform_remote_state.network-security.outputs.public_subnets
  security_group_ids = [data.terraform_remote_state.network-security.outputs.alb_security_group_id]
  hosted_zone_id     = data.terraform_remote_state.route53.outputs.hosted_zone_id
  certificate_arn    = data.terraform_remote_state.acm.outputs.certificate_arn
}

module "ecs" {
  source = "./modules/ecs"

  client_image              = var.client_image
  server_image              = var.server_image
  client_tg_arn             = module.alb.client_tg_arn
  server_tg_arn             = module.alb.server_tg_arn
  private_subnets           = data.terraform_remote_state.network-security.outputs.private_subnets
  public_subnets            = data.terraform_remote_state.network-security.outputs.public_subnets
  client_security_group_ids = [data.terraform_remote_state.network-security.outputs.client_service_security_group_id]
  server_security_group_ids = [data.terraform_remote_state.network-security.outputs.server_service_security_group_id]
  depends_on                = [module.alb]
}

data "terraform_remote_state" "network-security" {
  backend = "s3"
  config = {
    bucket = var.network_bucket
    key    = var.network_bucket_key
    region = var.network_bucket_region
  }
}

data "terraform_remote_state" "route53" {
  backend = "s3"
  config = {
    bucket = var.route53_bucket
    key    = var.route53_bucket_key
    region = var.route53_bucket_region
  }
}

data "terraform_remote_state" "acm" {
  backend = "s3"
  config = {
    bucket = var.acm_bucket
    key    = var.acm_bucket_key
    region = var.acm_bucket_region
  }
}