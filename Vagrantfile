# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = "hashicorp/precise32"
  config.vm.define :elk do |elk|
    elk.vm.network :private_network, :ip => "10.1.2.3"
  end
  
  config.vm.provider :virtualbox do |vb|
	vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
  
  config.vm.provision :shell, :path => "bash_provisioning.sh"
  
end
