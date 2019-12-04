#export ENV=prod2
#export ENV=stage
include .env-$(ENV)
export TF_VAR_file_account
export TF_VAR_project
export TF_VAR_grafana_password
export TF_VAR_location

VARS=variables/mbelousov-terraform-$(ENV).tfvars
init:
	terraform init

apply:
	env && terraform apply -var-file="$(VARS)" -auto-approve

plan:
	env && terraform plan -var-file="$(VARS)"

destroy:
	terraform destroy -auto-approve -target=module.helm_prometheus -target=module.helm_loki -target=module.helm_ingress
	terraform destroy -auto-approve
