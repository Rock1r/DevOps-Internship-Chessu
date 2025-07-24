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
  egress_rules = ["all-all"]
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
      description              = "Allow from alb"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]
  egress_rules = ["all-all"]
}

module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "alb"
  description = "SG for ALB"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]
  egress_rules        = ["all-all"]
}

module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db"
  description = "SG for db, allows port 5432 from server-service"
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

module "ecr_endpoint_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ecr-endpoint"
  description = "Allow HTTPS from ECS tasks"
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "Allow HTTPS from client-service"
      source_security_group_id = module.client_service_sg.security_group_id
    },
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "Allow HTTPS from server-service"
      source_security_group_id = module.server_service_sg.security_group_id
    },
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "Allow HTTPS from jenkins node"
      source_security_group_id = module.jenkins_node_sg.security_group_id
    }
  ]


  egress_rules = ["all-all"]
}

module "jenkins_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins"
  description = "SG for jenkins"
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 8080
      to_port                  = 8080
      protocol                 = "tcp"
      description              = "Allow from ALB"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]
  egress_rules = ["all-all"]
}

module "jenkins_node_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-node"
  description = "SG for jenkins"
  vpc_id      = var.vpc_id


  ingress_with_source_security_group_id = [
    {
      from_port                = 0
      to_port                  = 50001
      protocol                 = "tcp"
      description              = "Allow JNLP from Jenkins master"
      source_security_group_id = module.jenkins_sg.security_group_id
    }
  ]

  egress_rules = ["all-all"]
}
