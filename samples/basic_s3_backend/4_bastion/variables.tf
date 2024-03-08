variable "bastion_iam_role_name" {
  description = ""
  type = string
  default = ""
}

variable "instance_type" {
  description = ""
  type = string
  default = ""
}

variable "key_name" {
  description = ""
  type = string
  default = ""
}

variable "prefix" {
  description = "Prefix Name for Environment"
  type = string
  default = "prefix"
}

variable "tfstate_bucket_name" {
  description = "s3 bucket name of tfstate backend"
  type = string
  default = ""
}

variable "region" {
  default = "ap-northeast-2"
}
