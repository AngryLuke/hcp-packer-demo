# Step-0 Setup Packer buckets, channels and HCP TF resources
In the setup folder, fill the tfvars config file with your HCP project, client secret and client id and HCP TF organization.
hcp_project_id = ""
hcp_client_secret = ""
hcp_client_id = ""
hcp_tf_org_name = ""

 ```
terraform init
terraform login 
terraform apply
 ```

Make sure that the workspace created has the HCP Packer credentials (project id, client secret and client id) accessible as variables (i use varsets and automatically attach them). Same for AWS creds.

# Step-1 Build the Packer base image
Before building the packer image, you need to pass the HCP Packer registry credentials.
 ```
export HCP_CLIENT_ID=
export HCP_CLIENT_SECRET=
export HCP_PROJECT_ID=
eval $(doormat aws export --account YOURDOORMATACCOUNT) //Necessary as we are building AMIs and pushing them to AWS
packer init . 
packer validate base-image.pkr.hcl
packer build base-image.pkr.hcl
 ```

# Step-2 Build the Packer app image using the base image as parent
Before building the packer image, you need to pass the HCP Packer registry credentials.
 ```
export HCP_CLIENT_ID=
export HCP_CLIENT_SECRET=
export HCP_PROJECT_ID=
eval $(doormat aws export --account YOURDOORMATACCOUNT) //Necessary as we are building AMIs and pushing them to AWS
packer init . 
packer validate application.pkr.hcl
packer build application.pkr.hcl
 ```

Check on the Packer portal to see the relationship between the two images.

# Step-3 Deploy infra using the app image AMI created in step 2

Edit the main.tf in line 3 to match your HCP TF organization
 ```
 cd 3_infra_provisioning

terraform plan
terraform apply
