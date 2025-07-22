resource "aws_ecs_task_definition" "client" {
  family                   = "client-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::122627526984:role/ecsTaskExecutionRole"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([
    {
      name      = "client"
      image     = var.client_image
      essential = true
      cpu       = 256
      memory    = 512
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.chessu_client_logs.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      enable_cloudwatch_logging = false
      environment = [
        {
          name  = "HOSTNAME"
          value = "0.0.0.0"
        }
      ]
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "server" {
  family                   = "server-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::122627526984:role/ecsTaskExecutionRole"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([
    {
      name      = "server"
      image     = var.server_image
      essential = true
      cpu       = 256
      memory    = 512
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.chessu_server_logs.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      portMappings = [
        {
          containerPort = 3001
          protocol      = "tcp"
        }
      ]
      Environment = [
        {
          name  = "PGSSLMODE"
          value = "verify-full"
        },
        {
          name  = "PGAPPNAME"
          value = "chessu"
        },
        {
          name  = "NODE_EXTRA_CA_CERTS"
          value = "/var/db_cert.pem"
        }
      ]
      secrets = [
        {
          name      = "CORS_ORIGIN"
          valueFrom = "arn:aws:ssm:us-east-1:122627526984:parameter/server/cors_origin"
        },
        {
          name      = "PGHOST"
          valueFrom = "arn:aws:ssm:us-east-1:122627526984:parameter/server/pghost"
        },
        {
          name      = "PGDATABASE"
          valueFrom = "arn:aws:ssm:us-east-1:122627526984:parameter/server/pgdatabase"
        },
        {
          name      = "PGUSER"
          valueFrom = "arn:aws:ssm:us-east-1:122627526984:parameter/server/pguser"
        },
        {
          name      = "PGPASSWORD"
          valueFrom = "arn:aws:ssm:us-east-1:122627526984:parameter/server/pgpassword"
        },
        {
          name      = "SESSION_SECRET"
          valueFrom = "arn:aws:ssm:us-east-1:122627526984:parameter/server/session_secret"
        }
      ]
    }
  ])
}

resource "aws_cloudwatch_log_group" "chessu_server_logs" {
  name              = "chessu-server-logs"
  retention_in_days = 7
  region            = var.region
  tags = {
    Environment = "development"
    Application = "server"
  }
}

resource "aws_cloudwatch_log_group" "chessu_client_logs" {
  name              = "chessu-client-logs"
  retention_in_days = 7
  region            = var.region
  tags = {
    Environment = "development"
    Application = "client"
  }
}