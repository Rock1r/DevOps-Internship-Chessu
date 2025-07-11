module "client_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "client-service"
  description = "SG for client-service, allows port 3000 from ALB"
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 3000
      to_port                  = 3000
      protocol                 = "tcp"
      description              = "Allow from ALB"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]
}
    
module "server_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "server-service"
  description = "SG for server-service, allows port 3001 from user-service"
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 3001
      to_port                  = 3001
      protocol                 = "tcp"
      description              = "Allow from client-service"
      source_security_group_id = module.client_service_sg.security_group_id
    }
  ]
}

module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "alb"
  description = "SG for ALB, allows port 80 from 0.0.0.0/0"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db-service"
  description = "SG for db-service, allows port 5432 from server-service"
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      description              = "Allow from server-service"
      source_security_group_id = module.server_service_sg.security_group_id
    }
  ]
}
