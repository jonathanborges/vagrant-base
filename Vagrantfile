# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"

  config.vm.box_check_update = true

  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 3306, host: 3306

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder "./www", "/var/www",
    owner: "ubuntu", group: "www-data"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "vagrant-base"
    vb.memory = "512"
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.provision "shell", path: "environment/bootstrap.sh"
end
