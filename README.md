# terraform stack
terraform playbooks for gcp, k8s, prometheus, loki, grafana


##Set up the GCP environment
1.  GCP auth
gcloud auth application-default login

2. Create a new project

- set Enviroment
export ENV=stage

- configure GCP
export TF_VAR_billing_account=YOUR_BILLING_ACCOUNT_ID
*Note you can find OUR_BILLING_ACCOUNT_ID by run
gcloud alpha billing accounts list
**
export GCP_PROJECT_ID=<your GCP PROJECT ID>
export TF_ADMIN=${GCP_PROJECT_ID}-${ENV}
export TF_CREDS=${GCP_PROJECT_ID}-${ENV}.json
gcloud projects create ${GCP_PROJECT_ID} \
  --set-as-default
gcloud beta billing projects link ${GCP_PROJECT_ID} \
  --billing-account ${TF_VAR_billing_account}


3. Create the Terraform service account
gcloud iam service-accounts create terraform-${ENV} \
  --display-name "Terraform admin account"

gcloud iam service-accounts keys create ${TF_CREDS} \
  --iam-account terraform-${ENV}@${GCP_PROJECT_ID}.iam.gserviceaccount.com

4. Grant the service account permission
gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} \
  --member serviceAccount:terraform-${ENV}@${GCP_PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/owner

5. Any actions that Terraform performs require that the API be enabled to do so. In this guide, Terraform requires the following:

gcloud services enable cloudkms.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable logging.googleapis.com
gcloud services enable monitoring.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable compute.googleapis.com

##Makefile
make init
make plan
make apply
make destroy


##TERRAFORM
#Run
terraform init
terraform apply -var-file=terraform.tfvars

#Clear
terraform destroy -auto-approve \
 -target=module.helm_prometheus \
 -target=module.helm_loki \
 -target=module.helm_ingress

terraform destroy -auto-approve

#To do
1. Makefile +Done
2. modules depending
3. module for gke project, account etc
4. add grafana ds using provider
5. add module firewall for gcp
