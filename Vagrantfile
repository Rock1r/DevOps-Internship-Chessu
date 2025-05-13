Vagrant.configure("2") do |config|
  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/jammy64"
    db.vm.network "private_network", ip: "192.168.50.4"
    db.vm.synced_folder ".", "/vagrant"

    db.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
    db.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "ansible/db_playbook.yml"
    end
  end

  config.vm.define "client" do |client|
    client.vm.box = "ubuntu/jammy64"
    client.vm.network "private_network", ip: "192.168.50.2"
    client.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
    client.vm.network "forwarded_port", guest: 3000, host: 3000

    client.vm.synced_folder ".", "/vagrant"

    client.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "ansible/app_playbook.yml"
      ansible.extra_vars = {
        name: "client",
      }
    end
  end

  config.vm.define "server" do |server|
    server.vm.box = "ubuntu/jammy64"
    server.vm.network "private_network", ip: "192.168.50.3"
    server.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 4
    end

    server.vm.network "forwarded_port", guest: 3001, host: 3001

    server.vm.synced_folder ".", "/vagrant"

    server.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "ansible/app_playbook.yml"
      ansible.extra_vars = {
        name: "server",
      }
    end
  end
end
