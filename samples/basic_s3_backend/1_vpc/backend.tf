terraform {
  backend "s3" {
      key            = "terraform/1_vpc/terraform.tfstate"
      encrypt        = true
  }
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path    = "../1_vpc/terraform.tfstate"
  }
}