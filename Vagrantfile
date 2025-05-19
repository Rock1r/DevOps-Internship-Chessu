Vagrant.configure("2") do |config|
  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/jammy64"
    db.vm.network "private_network", ip: "192.168.50.4"

    db.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end

    db.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "client" do |client|
    client.vm.box = "ubuntu/jammy64"
    client.vm.network "private_network", ip: "192.168.50.2"
    client.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
    client.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "server" do |server|
    server.vm.box = "ubuntu/jammy64"
    server.vm.network "private_network", ip: "192.168.50.3"
    server.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end

    server.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "ansible" do |ansible|
    ansible.vm.box = "ubuntu/jammy64"
    ansible.vm.network "private_network", ip: "192.168.50.1"
    ansible.vm.synced_folder ".", "/vagrant"
    ansible.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 4
    end
    ansible.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y python3-pip
      pip3 install passlib

      pip3 install ansible

      ansible-galaxy collection install community.postgresql:3.14.0
      ansible-galaxy collection install community.general
      cp /vagrant/ansible/.vault_pass.txt /tmp/.vault_pass.txt
      chmod 600 /tmp/.vault_pass.txt
      if ! grep -q '^$ANSIBLE_VAULT;' /vagrant/ansible/secrets.yml; then
        ansible-vault encrypt /vagrant/ansible/secrets.yml --vault-password-file /tmp/.vault_pass.txt
      fi
      ansible-playbook -i /vagrant/ansible/hosts.ini /vagrant/ansible/master.yml -e "@/vagrant/ansible/secrets.yml" --vault-password-file /tmp/.vault_pass.txt
      ansible-vault decrypt /vagrant/ansible/secrets.yml --vault-password-file /tmp/.vault_pass.txt
      rm -f /tmp/.vault_pass.txt
    SHELL
  end
end
