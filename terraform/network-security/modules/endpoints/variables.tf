variable "ecr_region" {
  description = "The AWS region where the ECR endpoint will be created."
  type        = string
  default     = "us-east-1"
}

variable "ssm_region" {
  description = "The AWS region where the SSM endpoint will be created."
  type        = string
  default     = "us-east-1"
}

variable "logs_region" {
  description = "The AWS region where the CloudWatch Logs endpoint will be created."
  type        = string
  default     = "us-east-1"
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the VPC endpoints."
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC where the endpoints will be created."
  type        = string
}

variable "vpc_private_route_table_ids" {
  description = "List of private route table IDs for the VPC endpoints."
  type        = list(string) 
}

variable "private_subnets" {
  description = "List of private subnet IDs for the VPC endpoints."
  type        = list(string)
  
}