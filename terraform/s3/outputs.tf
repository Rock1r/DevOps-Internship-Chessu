output "logs_bucket_name" {
  value = module.alb-logs-bucket.s3_bucket_id
}

output "chessu-tfstate_bucket_name" {
    value = module.chessu-bucket.s3_bucket_id
}

output "chessu-db-tfstate_bucket_name" {
    value = module.chessu-db-bucket.s3_bucket_id
}