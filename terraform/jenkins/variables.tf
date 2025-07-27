variable "alb_bucket" {
  description = "The S3 bucket for remote state storage"
  type        = string
}

variable "alb_bucket_key" {
  description = "The S3 key for remote state storage"
  type        = string
}

variable "alb_bucket_region" {
  description = "The AWS region for remote state storage"
  type        = string
}

variable "network_bucket" {
  description = "The S3 bucket for remote state storage"
  type        = string
}

variable "network_bucket_key" {
  description = "The S3 key for remote state storage"
  type        = string
}

variable "network_bucket_region" {
  description = "The AWS region for remote state storage"
  type        = string
}

variable "ecr_bucket" {
  description = "The S3 bucket for remote state storage"
  type        = string
}

variable "ecr_bucket_key" {
  description = "The S3 key for remote state storage"
  type        = string
}

variable "ecr_bucket_region" {
  description = "The AWS region for remote state storage"
  type        = string
}

variable "jenkins_bucket_name" {
  type = string
}