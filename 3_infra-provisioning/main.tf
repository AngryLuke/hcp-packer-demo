# terraform {
#   cloud {
#     organization = "hashicorp-italy"

#     workspaces {
#       name = "app-deployment"
#     }
#   }
# }

provider "aws" {
  region = var.region
}

provider "hcp" {
}