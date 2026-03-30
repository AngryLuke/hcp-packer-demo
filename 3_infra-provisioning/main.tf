# terraform {
#   cloud {
#     organization = "hashicorp-italy"

#     workspaces {
#       name = "app-deployment"
#     }
#   }
# }

# adding a comment here to trigger a new run of the pipeline
provider "aws" {
  region = var.region
}

provider "hcp" {
}