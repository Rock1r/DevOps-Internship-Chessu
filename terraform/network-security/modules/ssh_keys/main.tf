resource "tls_private_key" "jenkins_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins"
  public_key = tls_private_key.jenkins_key.public_key_openssh
}

resource "tls_private_key" "jenkins_node_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jenkins_node_key" {
  key_name   = "jenkins-node"
  public_key = tls_private_key.jenkins_node_key.public_key_openssh
}

