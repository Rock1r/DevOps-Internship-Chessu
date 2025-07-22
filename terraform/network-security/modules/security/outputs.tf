output "alb_security_group_id" {
  value = module.alb_sg.security_group_id
}

output "client_service_security_group_id" {
  value = module.client_service_sg.security_group_id
}

output "server_service_security_group_id" {
  value = module.server_service_sg.security_group_id
}

output "db_security_group_id" {
  value = module.db_sg.security_group_id
}

output "ecr_endpoint_security_group_id" {
  value = module.ecr_endpoint_sg.security_group_id
}

output "jenkins_sg_id" {
  value = module.jenkins_sg.security_group_id
}