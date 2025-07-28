module "chessu-bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "chessu-tfstate"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}

module "chessu-db-bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "chessu-db-tfstate"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}

module "jenkins-bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "chessu-jenkins"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = false
  }
}

module "alb-logs-bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "chessu-alb-logs"

  force_destroy = true

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  attach_elb_log_delivery_policy = true
  attach_lb_log_delivery_policy  = true
}