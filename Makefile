
dev:
	terraform init
	dotenvx run -- terraform apply -auto-approve

make apply: dev
fmt:
	terraform fmt -recursive
state:
	terraform state list

destroy:
	dotenvx run -- terraform destroy -auto-approve

up: apply
down: destroy



