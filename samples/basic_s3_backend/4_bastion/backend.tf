data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path    = "../1_vpc/terraform.tfstate"
  }
}