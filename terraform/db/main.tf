module "db" {
  source      = "git@github.com:Rock1r/chessu-db.git//terraform?ref=main"
  db_name     = var.db_name
  db_username = var.db_username
  db_port     = var.db_port

  parameter_store_name = var.parameter_store_name
  db_sg                = [data.terraform_remote_state.network-security.outputs.db_sg]
  private_subnet_ids   = data.terraform_remote_state.network-security.outputs.private_subnets
}

data "terraform_remote_state" "network-security" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = var.remote_state_key
    region = var.remote_state_region
  }
}