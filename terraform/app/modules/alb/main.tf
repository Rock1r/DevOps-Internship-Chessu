module "alb" {
  source                     = "terraform-aws-modules/alb/aws"
  name                       = "chessu-alb"
  vpc_id                     = var.vpc_id
  subnets                    = var.public_subnets
  enable_deletion_protection = false
  security_groups            = var.security_group_ids
  create_security_group      = false
  listeners = {
    https-reverse-proxy = {
      port     = 443
      protocol = "HTTPS"
      certificate_arn = var.certificate_arn
      forward = {
        target_group_key = "client"
      }
      rules = {
        proxy-client = {
          priority = 2
          actions = [{
            type             = "forward"
            target_group_key = "client"
          }]
          conditions = [{
            path_pattern = {
              values = ["/*"]
            }
          }]
        },
        proxy-server = {
          priority = 1
          actions = [{
            type             = "forward"
            target_group_key = "server"
          }]
          conditions = [{
            path_pattern = {
              values = ["/v1/*", "/socket.io/*"]
            }
          }]
        }
      }
    }
  }

  target_groups = {
    client = {
      name_prefix = "client"
      protocol    = "HTTP"
      port        = 3000
      target_type = "ip"
      target_group_health = {
        dns_failover = {
          minimum_healthy_targets_count = 1
        }
        unhealthy_state_routing = {
          minimum_healthy_targets_percentage = 50
        }
      }

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = 3000
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 10
        protocol            = "HTTP"
        matcher             = "200-499"
      }
      create_attachment = false
    }

    server = {
      name_prefix = "server"
      protocol    = "HTTP"
      port        = 3001
      target_type = "ip"
      target_group_health = {
        dns_failover = {
          minimum_healthy_targets_count = 1
        }
        unhealthy_state_routing = {
          minimum_healthy_targets_percentage = 50
        }
      }

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/healthz"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-499"
      }
      create_attachment = false
    }
  }

  tags = {
    Environment = "Development"
    Project     = "Chessu"
  }
}