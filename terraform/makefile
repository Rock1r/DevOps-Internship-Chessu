.PHONY:  jenkins app

default: infrastructure

infrastructure: app jenkins

app:
	cd network-security && terraform apply -auto-approve
	cd app && terraform apply -auto-approve

destroy:
	cd network-security && terraform destroy -target module.endpoints -auto-approve && terraform destroy -target  module.network.module.vpc.aws_eip.nat -auto-approve && terraform destroy -target module.network.module.vpc.aws_nat_gateway.this -auto-approve
	cd app && terraform destroy -target module.ecs -auto-approve

jenkins:
	cd app && terraform apply -target module.alb -auto-approve
	cd jenkins && terraform apply -auto-approve

fmt:
	terraform fmt -recursive

init:
	for dir in */; do \
		if [ -f $$dir/main.tf ]; then \
			cd $$dir && terraform init && cd -; \
		fi \
	done
