variable "domain" {
  type = string
  default = "chessu.pp.ua"
}

variable "remote_state_bucket" {
  description = "The S3 bucket for remote state storage"
  type        = string
}

variable "remote_state_key" {
  description = "The S3 key for remote state storage"
  type        = string
}

variable "remote_state_region" {
  description = "The AWS region for remote state storage"
  type        = string
}