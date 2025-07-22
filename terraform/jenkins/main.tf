module "jenkins_data" {
  source = "./modules/ebs"
}

module "iam" {
  source = "./modules/iam"
  client_repo = data.terraform_remote_state.ecr.outputs.client_repository_arn
  server_repo = data.terraform_remote_state.ecr.outputs.server_repository_arn
  jenkins_bucket_name = var.jenkins_bucket_name
}

module "jenkins_instance" {
  source = "./modules/ec2"
  jenkins_master_role_name = module.iam.jenkins_master_iam_role_name
  public_subnets = data.terraform_remote_state.network-security.outputs.public_subnets
  jenkins_security_group_ids = [data.terraform_remote_state.network-security.outputs.jenkins_security_group_id]
  volume_id = module.jenkins_data.jenkins_data_id
  target_group_arn = data.terraform_remote_state.alb.outputs.jenkins_tg
  jenkins_master_key_name = data.terraform_remote_state.network-security.outputs.jenkins_master_key_name
}

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = var.alb_bucket
    key    = var.alb_bucket_key
    region = var.alb_bucket_region
  }
}

data "terraform_remote_state" "network-security" {
  backend = "s3"
  config = {
    bucket = var.network_bucket
    key    = var.network_bucket_key
    region = var.network_bucket_region
  }
}

data "terraform_remote_state" "ecr" {
  backend = "s3"
  config = {
    bucket = var.ecr_bucket
    key    = var.ecr_bucket_key
    region = var.ecr_bucket_region
  }
}