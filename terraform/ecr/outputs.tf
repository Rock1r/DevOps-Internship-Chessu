output "server_repository_arn" {
  value = aws_ecr_repository.server.arn
}

output "client_repository_arn" {
  value = aws_ecr_repository.client.arn
} 