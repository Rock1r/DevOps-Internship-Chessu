.PHONY:  jenkins app

default: infrastructure

infrastructure: app jenkins

app:
	cd network-security && terraform apply -auto-approve
	cd app && terraform apply -auto-approve

destroy:
	cd network-security && terraform destroy -target module.endpoints -auto-approve
	cd jenkins && terraform destroy -target module.jenkins_instance -auto-approve
	cd app && terraform destroy -auto-approve

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
