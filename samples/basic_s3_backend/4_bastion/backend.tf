terraform {
  backend "s3" {
      key            = "terraform/4_bastion/terraform.tfstate"
      encrypt        = true
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.tfstate_bucket_name
    region = var.region
    key    = "terraform/1_vpc/terraform.tfstate"
  }
}