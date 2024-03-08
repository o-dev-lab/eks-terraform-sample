# variables.tf
variable "region" {
  default = "ap-northeast-2"
}



variable "azs" {
  description = "A list of availability zones names or ids in the region"
  default     = []
  type        = list(string)
}

variable "prefix" {
  description = "Prefix Name for Environment"
  type        = string
  default     = "prefix"
}

variable "project" {
  description = "The Name of this project"
  type        = string
  default     = ""
}

variable "env" {
  description = "Environment"
  type        = string
  default     = "dev"
}


variable "image_names" {
  description = ""
  type        = list(string)
  default     = []
}

variable "aws_auth_users" {
  description = ""
  type        = list(string)
  default     = []
}

variable "eks_cluster_version" {
  
}

variable "eks_cluster_name" {
  
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster security group will be provisioned"
  type        = string
  default     = null
}

variable "private_subnet_ids" {
  description = "A list of subnet IDs where the nodes/node groups will be provisioned. If `control_plane_subnet_ids` is not provided, the EKS cluster control plane (ENIs) will be provisioned in these subnets"
  type        = list(string)
  default     = []
}

variable "cluster_security_group_id" {
  description = "Existing security group ID to be attached to the cluster"
  type        = string
  default     = ""
}

variable "bastion_iam_role_name" {
  description = ""
  type = string
  default = ""
}