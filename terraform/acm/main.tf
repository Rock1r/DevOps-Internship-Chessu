module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = var.domain
  zone_id     = data.terraform_remote_state.network-security.outputs.hosted_zone_id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain}"
  ]

  wait_for_validation = true

  tags = {
    Name = var.domain
  }
}

data "terraform_remote_state" "network-security" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = var.remote_state_key
    region = var.remote_state_region
  }
}