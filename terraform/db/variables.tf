
variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Username for the database"
  type        = string
}

variable "db_port" {
  description = "Port for the database"
  type        = string
  default     = "5432"
}

variable "remote_state_bucket" {
  description = "S3 bucket for remote state storage"
  type        = string
}

variable "remote_state_key" {
  description = "S3 key for remote state storage"
  type        = string
}

variable "remote_state_region" {
  description = "AWS region for remote state storage"
  type        = string
}

variable "parameter_store_name" {
  description = "Parameter Store name for the database host"
  type        = string
}