variable "client_image" {
  description = "The ECR repository for the client service"
  type        = string
}

variable "server_image" {
  description = "The ECR repository for the server service"
  type        = string
}

variable "client_tg_arn" {
  description = "The ARN of the target group for the client service"
  type        = string
}

variable "server_tg_arn" {
  description = "The ARN of the target group for the server service"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for the ECS services"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet IDs for the ECS services"
  type        = list(string)

}

variable "client_security_group_ids" {
  description = "List of security group IDs for the client service"
  type        = list(string)
}

variable "server_security_group_ids" {
  description = "List of security group IDs for the server service"
  type        = list(string)
}

variable "region" {
  description = "The AWS region where the ECS services will be deployed"
  type        = string
  default     = "us-east-1"
}