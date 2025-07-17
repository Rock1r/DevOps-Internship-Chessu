variable "client_image" {
  description = "The ECR repository for the client service"
  type        = string
}

variable "server_image" {
  description = "The ECR repository for the server service"
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

variable "route53_bucket" {
  description = "The S3 bucket for remote state storage"
  type        = string
}

variable "route53_bucket_key" {
  description = "The S3 key for remote state storage"
  type        = string
}

variable "route53_bucket_region" {
  description = "The AWS region for remote state storage"
  type        = string
}

variable "acm_bucket" {
  description = "The S3 bucket for remote state storage"
  type        = string
}

variable "acm_bucket_key" {
  description = "The S3 key for remote state storage"
  type        = string
}

variable "acm_bucket_region" {
  description = "The AWS region for remote state storage"
  type        = string
}