#include .env

export TF_WORKSPACE=prod2
export GCP=mbelousov
export TF_ADMIN=${GCP}-terraform-${TF_WORKSPACE}
export TF_CREDS=${TF_ADMIN}.json
export TF_VAR_project=${TF_ADMIN}
export TF_VAR_location="us-east1-b"
export TF_VAR_kubernetes_version="1.14.8-gke.17"
export TF_VAR_grafana_password="P@S;p"
#export TF_VAR_file_account=${TF_CREDS}


init:
	terraform init

apply:
	env && terraform apply -var-file=$(TF_ADMIN).tfvars

plan:
	terraform plan -var-file=terraform.tfvars

destroy:
	terraform destroy -auto-approve -target=module.helm_prometheus -target=module.helm_loki -target=module.helm_ingress
	terraform destroy -auto-approve
