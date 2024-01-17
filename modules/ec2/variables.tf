
variable "instance_type" {
  description = ""
  default = "t3.micro"
  type = string
}

variable "key_name" {
  description = ""
  default = ""
  type = string
}

variable "vpc_security_group_ids" {
  description = ""
  default = []
  type = list(string)
}

variable "subnet_id" {
  description = ""
  type = string
}

variable "tags" {
  description = ""
  default = {}
  type = map(string)
}

variable "iam_role_name" {
  description = ""
  default = ""
  type = string
}


variable "create_iam_instance_profile" {
  description = ""
  default = false
  type = bool
}

variable "iam_role_policies" {
  description = ""
  default = {}
  type = map(string)
}


variable "volume_type" {
  description = ""
  default = "gp3"
  type = string
}

variable "volume_size" {
  description = ""
  default = 8
  type = number
}