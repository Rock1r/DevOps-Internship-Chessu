output "server_repository_url" {
  value = aws_ecr_repository.server.repository_url
}

output "client_repository_url" {
  value = aws_ecr_repository.client.repository_url
}

output "client_repository_arn" {
  value = aws_ecr_repository.client.arn
}

output "server_repository_arn" {
  value = aws_ecr_repository.server.arn
}