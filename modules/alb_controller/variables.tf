# variables.tf

# variable "eks_cluster_endpoint" {
#   description = ""
#   type = string
#   default = null
# }

# variable "auth_token" {
#   description = ""
#   type = string
#   default = null
# }

# variable "cluster_certificate_authority_data" {
#   description = ""
#   type = string
#   default = null
# }

variable "cluster_oidc_issuer_url" {
  description = ""
  type = string
  default = null
}

variable "alb_controller_iam_policy" {
  description = ""
  type = string
  default = null
}

variable "eks_cluster_id" {
  description = ""
  type = string
  default = null
}

variable "vpc_id" {
  description = ""
  type = string
  default = null
}

variable "prefix" {
  description = ""
  type = string
  default = null
}

variable "region" {
  description = ""
  type = string
  default = null
}