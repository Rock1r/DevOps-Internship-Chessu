module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = var.vpc_id
  security_group_ids = var.security_group_ids
  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = var.vpc_private_route_table_ids
    }
    ecr = {
      service_name        = "com.amazonaws.${var.ecr_region}.ecr.api"
      subnet_ids          = var.private_subnets
      private_dns_enabled = true
    }
    ecr_docker = {
      service_name        = "com.amazonaws.${var.ecr_region}.ecr.dkr"
      subnet_ids          = var.private_subnets
      private_dns_enabled = true
    }
    logs = {
      service_name        = "com.amazonaws.${var.logs_region}.logs"
      subnet_ids          = var.private_subnets
      private_dns_enabled = true
    }
    ssm = {
      service_name        = "com.amazonaws.${var.ssm_region}.ssm"
      subnet_ids          = var.private_subnets
      private_dns_enabled = true
    }
  }
}
