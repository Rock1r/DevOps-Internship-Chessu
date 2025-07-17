default: infrastructure

infrastructure:


save-money:
	cd network-security && terraform destroy -target module.endpoints -auto-approve
	cd app && terraform destroy -auto-approve