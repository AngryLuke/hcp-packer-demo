data "tfe_organization" "my-org" {
  name = var.hcp_tf_org_name
}

resource "tfe_project" "hcptf_proj" {
  organization = data.tfe_organization.my-org.name
  name = "Packer-demo"
}

resource "tfe_workspace" "test" {
  name         = "app-deployment"
  organization = data.tfe_organization.my-org.name
  project_id = tfe_project.hcptf_proj.id
}