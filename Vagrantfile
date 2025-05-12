Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 3001, host: 3001

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "ansible/playbook.yml"
  end
end
