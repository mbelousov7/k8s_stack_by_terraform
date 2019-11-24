include .env

export TF_VAR_project
export TF_VAR_location
export TF_VAR_kubernetes_version
export TF_VAR_password
export TF_VAR_file_account


init:
	terraform init

apply:
	terraform apply -var-file=terraform.tfvars

plan:
	terraform plan -var-file=terraform.tfvars

destroy:
	terraform destroy -auto-approve -target=module.helm_prometheus -target=module.helm_loki -target=module.helm_ingress & terraform destroy -auto-approve
