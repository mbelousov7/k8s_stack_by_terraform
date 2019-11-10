# terraform stack
terraform playbooks for gcp, k8s, prometheus, grafana


##Set up the environment

1. Set the project, replace YOUR_PROJECT with your project ID:

PROJECT=YOUR_PROJECT
gcloud config set project ${PROJECT}

PROJECT=terraform2-258610
gcloud config set project ${PROJECT}
2. Configure the environment for Terraform:
[[ $CLOUD_SHELL ]] || gcloud auth application-default login
export GOOGLE_PROJECT=$(gcloud config get-value project)
3. Create the terraform.tfvars file:

cat > terraform.tfvars <<EOF
helm_version = "$(helm version -c --short | egrep -o 'v[0-9]*.[0-9]*.[0-9]*')"
acme_email = "$(gcloud config get-value account)"
EOF

cat terraform.tfvars
**

#Enable service management API

This example creates a Cloud Endpoints service and requires that the Service Manangement API is enabled.

1. Enable the Service Management API:
gcloud services enable servicemanagement.googleapis.com


gcloud beta container clusters get-credentials example-cluster --region us-east1-b --project terraform3-258612
