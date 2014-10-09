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

- The script start Jetty on port `localhost:8082`, because most IDE already
provide a managed AS to debug and profile this should avoid port clashes.
- The provision script handles either the startup of the services, so use
`vagrant up --provision` at first run or call `/vagrant/provision.sh` inside the VM
to have services running


