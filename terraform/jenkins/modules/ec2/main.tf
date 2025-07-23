module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = "jenkins-master"
  ami                         = "ami-020cba7c55df1f615"
  instance_type               = "t2.small"
  subnet_id                   = var.public_subnets[0]
  create_security_group       = false
  vpc_security_group_ids      = var.jenkins_security_group_ids
  associate_public_ip_address = true
  user_data                   = local.user_data
  key_name                    = var.jenkins_master_key_name
  create_iam_instance_profile = false
  iam_instance_profile        = var.jenkins_master_profile
  user_data_replace_on_change = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_volume_attachment" "jenkins_ebs_attach" {
  device_name  = "/dev/xvdf"
  volume_id    = var.volume_id
  instance_id  = module.ec2_instance.id
  force_detach = true
}

resource "aws_lb_target_group_attachment" "jenkins" {
  target_group_arn = var.target_group_arn
  target_id        = module.ec2_instance.id
  port             = 8080
}

locals {
  user_data = file("./jenkins.sh")
}