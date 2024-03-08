# variables.tf
variable "region" {
  default = "ap-northeast-2"
}


variable "prefix" {
  description = "Prefix Name for Environment"
  type        = string
  default     = "prefix"
}


variable "namespace_names" {
  description = ""
  type        = list(string)
  default     = []
}

variable "aws_auth_users" {
  description = ""
  type        = list(string)
  default     = []
}

variable "eks_cluster_id" {
  
}

variable "vpc_id" {
  
}

variable "cluster_oidc_issuer_url" {
  
}

variable "fargate_profiles" {
  description = "Map of Fargate Profile definitions to create"
  type        = any
  default     = {}
}