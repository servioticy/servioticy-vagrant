# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

#unless Vagrant.has_plugin?("vagrant-puppet-install")
#  raise 'vagrant-puppet-install is not installed!'
#end


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "hashicorp/precise64"
  #config.puppet_install.puppet_version = :latest
  
  # required by maven
  config.ssh.shell = "export JAVA_HOME=/usr/lib/jvm/java-7-oracle"

  # required by couchbase-cli
  config.ssh.shell = "export LC_ALL=\"en_US.UTF-8\""
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  #config.vm.provision "shell", path: "provision.sh"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "192.168.56.101"

  config.vm.provider :virtualbox do |vb|
    #vb.gui = true
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    #unless File.exist?("./datadisk.vdi")        
    #  vb.customize ['createhd', '--filename', './datadisk.vdi', '--size', 2 * 1024]
    #  vb.customize ['storageattach', :id, '--storagectl', "SATA Controller", '--port', 1, '--device', 0, '--type', 'hdd', '--medium', './datadisk.vdi' ]
    #end
  end
  
  #config.vm.provision :shell, :inline => "sudo apt-get update && sudo apt-get install puppet -y"
  config.vm.provision :shell, :path => "install_puppet.sh"
  
  #puppet config
  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "puppet/modules"
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "."
    #puppet.options = "--environment dev --graph --graphdir /vagrant/puppet/dependency_graph"
    puppet.options = "--environment dev"
  end
  
  # jetty
  config.vm.network :forwarded_port, guest: 8080, host: 8080
  config.vm.network :forwarded_port, guest: 8443, host: 8443

  # couchbase
  config.vm.network :forwarded_port, guest: 8092, host: 8092
  config.vm.network :forwarded_port, guest: 8091, host: 8091
  config.vm.network :forwarded_port, guest: 11210, host: 11210

  # elastic search
  config.vm.network :forwarded_port, guest: 9200, host: 9200

  # sqlite DB
  config.vm.network :forwarded_port, guest: 5010, host: 5010
  
  # MySQL
    config.vm.network :forwarded_port, guest: 3306, host: 3306
    
  # IDM
  config.vm.network :forwarded_port, guest: 8082, host: 8082
  
  # UAA
    config.vm.network :forwarded_port, guest: 8081, host: 8081
    
  
  #apollo
  #tcp://0.0.0.0:1883
  config.vm.network :forwarded_port, guest: 1883, host: 1883
  #tls://0.0.0.0:61614
  config.vm.network :forwarded_port, guest: 61614, host: 61614
  #ws://0.0.0.0:61623/
  config.vm.network :forwarded_port, guest: 61623, host: 61623
  #wss://0.0.0.0:61624/
  config.vm.network :forwarded_port, guest: 61624, host: 61624
  #http://0.0.0.0:61680/
  config.vm.network :forwarded_port, guest: 61680, host: 61680
  #https://0.0.0.0:61681/
  config.vm.network :forwarded_port, guest: 61681, host: 61681

end
