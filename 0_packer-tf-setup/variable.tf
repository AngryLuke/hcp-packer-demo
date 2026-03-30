variable "region" {
  default = "eu-west-1"
}

variable "hcp_tf_org_name" {

}

# variable "github_token" {
#  type      = string
#  sensitive = true
# }

variable "hcp_client_id" {
  type      = string
  sensitive = true
}

variable "hcp_client_secret" {
  type      = string
  sensitive = true
}

variable "hcp_project_id" {
  type = string
}