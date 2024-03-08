terraform {
  backend "s3" {
      key            = "terraform/1_vpc/terraform.tfstate"
      encrypt        = true
  }
}
