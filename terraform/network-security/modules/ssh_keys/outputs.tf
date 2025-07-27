output "jenkins_master_key" {
  value = tls_private_key.jenkins_key.private_key_pem
}

output "jenkins_master_key_name" {
  value = aws_key_pair.jenkins_key.key_name
}

output "jenkins_node_key" {
  value = tls_private_key.jenkins_node_key.private_key_pem
}

output "jenkins_node_key_name" {
  value = aws_key_pair.jenkins_node_key.key_name
}