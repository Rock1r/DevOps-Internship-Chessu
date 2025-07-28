Vagrant.configure("2") do |config|
  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/jammy64"
    db.vm.network "private_network", ip: "192.168.50.4"
    db.vm.hostname = "db"
    db.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end

    db.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "client" do |client|
    client.vm.box = "ubuntu/jammy64"
    client.vm.network "private_network", ip: "192.168.50.2"
    client.vm.hostname = "client"
    client.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
    client.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "server" do |server|
    server.vm.box = "ubuntu/jammy64"
    server.vm.network "private_network", ip: "192.168.50.3"
    server.vm.hostname = "server"
    server.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end

    server.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "server2" do |server2|
    server2.vm.box = "ubuntu/jammy64"
    server2.vm.network "private_network", ip: "192.168.50.5"
    server2.vm.hostname = "server2"
    server2.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end

    server2.vm.synced_folder ".", "/vagrant", disabled: true
  end
  
  config.vm.define "nginx" do |nginx|
    nginx.vm.box = "ubuntu/jammy64"
    nginx.vm.network "private_network", ip: "192.168.50.8"
    nginx.vm.hostname = "nginx"
    nginx.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end

    nginx.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "splunk" do |splunk|
    splunk.vm.box = "ubuntu/jammy64"
    splunk.vm.network "private_network", ip: "192.168.50.9"
    splunk.vm.hostname = "splunk"
    splunk.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 4
    end
    splunk.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y wget
      wget -O splunk-9.4.2-e9664af3d956-linux-amd64.tgz "https://download.splunk.com/products/splunk/releases/9.4.2/linux/splunk-9.4.2-e9664af3d956-linux-amd64.tgz"
    SHELL
    splunk.vm.synced_folder ".", "/vagrant", disabled: true
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

config.vm.define "node" do |node|
    node.vm.box = "ubuntu/jammy64"
    node.vm.hostname = "node"
    node.vm.network "private_network", ip: "192.168.50.10"
    node.vm.synced_folder ".", "/vagrant"
    node.vm.provider "virtualbox" do |vb|      
    vb.memory = "4096"
      vb.cpus = 4
    end
    node.vm.provision "shell", inline: <<-SHELL
      sudo apt update
sudo apt install fontconfig openjdk-21-jre -y 
    SHELL
  end

  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.box = "ubuntu/jammy64"
    jenkins.vm.network "private_network", ip: "192.168.50.6"
    jenkins.vm.network "forwarded_port", guest: 8080, host: 8080
    jenkins.vm.synced_folder ".", "/vagrant"
    jenkins.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"      
      vb.cpus = 4
    end
    jenkins.vm.provision "shell", inline: <<-SHELL
      sudo apt update
      sudo apt install fontconfig openjdk-21-jre -y 

      sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
        https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
      echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
        https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
        /etc/apt/sources.list.d/jenkins.list > /dev/null
      sudo apt-get update
      sudo apt-get install jenkins -y
      sudo systemctl start jenkins
    SHELL
  end
end
