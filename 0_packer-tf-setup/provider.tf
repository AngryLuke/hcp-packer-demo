terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.106.0"
    }
    tfe = {
      version = "~> 0.75.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

#provider "github" {
#  token = var.github_token
#}

provider "hcp" {
  client_id       = var.hcp_client_id
  client_secret   = var.hcp_client_secret
  project_id      = var.hcp_project_id
}

// Use the cloud provider AWS to provision resources that will be connected to HCP
provider "aws" {
  region = var.region
}