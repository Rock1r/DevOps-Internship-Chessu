variable "jenkins_master_profile" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "jenkins_security_group_ids" {
  type = list(string)
}

variable "volume_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "jenkins_master_key_name" {
  type = string
}