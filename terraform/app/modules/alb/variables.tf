variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "security_group_ids" {
  description = "The IDs of the security groups for the ALB"
  type        = list(string)
}

variable "hosted_zone_id" {
  description = "The ID of the Route 53 hosted zone for the ALB"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the ACM certificate for the ALB"
  type        = string
}