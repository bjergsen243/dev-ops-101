.DEFAULT_GOAL := plan
.PHONY: show init plan apply destroy

validate:
	terraform validate

show:
	terraform workspace show

init:
	terraform init --reconfigure

plan:
	terraform plan --var-file="input.tfvars"

plan-storage:
	terraform plan --var-file="input.tfvars" -target=module.storage

plan-backend:
	terraform plan --var-file="input.tfvars" -target=module.backend

plan-frontend:
	terraform plan --var-file="input.tfvars" -target=module.frontend

apply:
	terraform apply --auto-approve --var-file="input.tfvars"

apply-storage:
	terraform apply --auto-approve --var-file="input.tfvars" -target=module.storage

apply-backend:
	terraform apply --auto-approve --var-file="input.tfvars" -target=module.backend

apply-frontend:
	terraform apply --auto-approve --var-file="input.tfvars" -target=module.frontend

destroy:
	terraform destroy --auto-approve --var-file="input.tfvars"