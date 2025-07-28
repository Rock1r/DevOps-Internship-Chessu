output "jenkins_master_iam_profile" {
  value = aws_iam_instance_profile.jenkins_master_profile.name
}

output "jenkins_node_iam_profile" {
  value = aws_iam_instance_profile.jenkins_node_profile.arn
}