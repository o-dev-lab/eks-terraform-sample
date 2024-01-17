# variables.tf

variable "name" {
  description = ""
  type = string
  default = null
}

variable "vpc_id" {
  description = ""
  type = string
  default = null
}

variable "description" {
  description = ""
  type = string
  default = null
  
}

variable "ingress_lists" {
  description = ""
  type = any
  default = {}
}

variable "egress_lists" {
  description = ""
  type = any
  default = {}
}

variable "tags" {
  type = map(string)
  default = {}
}