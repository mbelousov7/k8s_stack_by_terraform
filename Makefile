include .env

export TF_VAR_project
export TF_VAR_location
export TF_VAR_kubernetes_version
export TF_VAR_password

help:						## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

init:
	terraform init

apply:
	terraform apply -auto-approve -var-file=terraform.tfvars

plan:
	terraform plan -var-file=terraform.tfvars

destroy:
	terraform destroy
