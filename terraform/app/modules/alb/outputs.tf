output "client_tg_arn" {
  value = module.alb.target_groups.client.arn
}

output "server_tg_arn" {
  value = module.alb.target_groups.server.arn
}


output "jenkins_tg_arn" {
  value = module.alb.target_groups.jenkins.arn
}