# terraform stack
terraform playbooks for gcp, k8s, prometheus, loki, grafana


##Set up the GCP environment
1.  GCP auth
gcloud auth application-default login

2. Create a new project

export TF_VAR_billing_account=YOUR_BILLING_ACCOUNT_ID
export TF_ADMIN=${USER}-terraform
export TF_CREDS=terraform-admin.json
gcloud projects create ${TF_ADMIN} \
  --set-as-default
gcloud beta billing projects link ${TF_ADMIN} \
  --billing-account ${TF_VAR_billing_account}

- Note you can find OUR_BILLING_ACCOUNT_ID by run

gcloud alpha billing accounts list

3. Create the Terraform service account
gcloud iam service-accounts create terraform \
  --display-name "Terraform admin account"

gcloud iam service-accounts keys create ${TF_CREDS} \
  --iam-account terraform@${TF_ADMIN}.iam.gserviceaccount.com

4. Grant the service account permission
gcloud projects add-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/owner

5. Any actions that Terraform performs require that the API be enabled to do so. In this guide, Terraform requires the following:

gcloud services enable cloudkms.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable logging.googleapis.com
gcloud services enable monitoring.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable compute.googleapis.com

# Run
terraform init
terraform apply -var-file=terraform.tfvars
terraform destroy -target=module.helm_prometheus,module.helm_loki,module.helm_ingress & terraform destroy

#To do
1. Makefile
2. modules dependings
3. create file yaml after destroy
4. module for gke project, account etc
