output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.network.vpc_id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.network.private_subnet_ids
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "db_sg" {
  description = "Security group ID for the database"
  value       = module.security.db_security_group_id
}

output "alb_security_group_id" {
  description = "Security group ID for the ALB"
  value       = module.security.alb_security_group_id
}

output "client_service_security_group_id" {
  description = "Security group ID for the client ECS service"
  value       = module.security.client_service_security_group_id
}

output "server_service_security_group_id" {
  description = "Security group ID for the server ECS service"
  value       = module.security.server_service_security_group_id
}
