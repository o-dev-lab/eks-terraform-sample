# variables.tf
variable "region" {
  default = "ap-northeast-2"
}



variable "azs" {
  description = "A list of availability zones names or ids in the region"
  default = []
  type = list(string)
}

variable "prefix" {
  description = "Prefix Name for Environment"
  type = string
  default = "prefix"
}

variable "vpc_cidr" {
  description = "VPC CIDR Range"
  type = string
  default = "10.0.0.0/16"
}

variable "tfstate_bucket_name" {
  description = "The Name of backend S3 bucket"
  type = string
  default = ""
}

variable "project" {
  description = "The Name of this project"
  type = string
  default = ""
}

variable "env" {
  description = "Environment"
  type = string
  default = "dev"
}

variable "company_ips_for_sg" {
  default = []
  type = list(string)
}


variable "tags" {
  description = ""
  type = map(string)
  default = {}
}

variable "public_subnet_tags" {
  description = ""
  type = map(string)
  default = {}
}

variable "private_subnet_tags" {
  description = ""
  type = map(string)
  default = {}
}

variable "eks_cluster_name" {
  
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


variable "namespace_names" {
  description = ""
  type        = list(string)
  default     = []
}

variable "bastion_iam_role_name" {
  
}