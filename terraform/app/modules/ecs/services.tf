resource "aws_ecs_service" "client" {
  name            = "client-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.client.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.public_subnets
    security_groups = var.client_security_group_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.client_tg_arn
    container_name   = "client"
    container_port   = 3000
  }

  enable_execute_command = true
}

resource "aws_ecs_service" "server" {
  name            = "server-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.server.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = var.server_security_group_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.server_tg_arn
    container_name   = "server"
    container_port   = 3001
  }

  enable_execute_command = true
}