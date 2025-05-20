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

  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.box = "ubuntu/jammy64"
    jenkins.vm.network "private_network", ip: "192.168.50.1"
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
