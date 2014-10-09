servioticy-vagrant
==================

**This vagrant box is under development and should be used ONLY for development purposes!**

Puppet is used to setup and launch all the needed components to run the servioticy API


##Requirements
You need to install the following vagrant plugin: vagrant-puppet-install

The procedure is:

`vagrant plugin install vagrant-puppet-install`

##Running  the instance

Now we are ready to run

`vagrant up --provision`


You can then login into the instance running:

`vagrant ssh`

##Notes

- The provision script handles either the startup of the services, so use
`vagrant up --provision` when starting the VM.


