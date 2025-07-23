resource "aws_ebs_volume" "jenkins_data" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp3"
  tags = {
    Name = "jenkins-data"
  }
  lifecycle {
    prevent_destroy = true
  }
}
