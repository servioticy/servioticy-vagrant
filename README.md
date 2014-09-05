servioticy-vagrant
==================

**This vagrant box is under development and should be used ONLY for development purposes!**

The `provision.sh` script should be able to setup and launch all the needed components to run the servioticy API

##Before run

Create a `./servioticy` directory and pull all the required repository to compile the appliance.
This has to be done manually in order to use the correct code.

For example

```
git clone https://github.com/servioticy/servioticy-vagrant.git

cd servioticy-vagrant
mkdir servioticy
cd servioticy

git clone https://github.com/servioticy/servioticy-api-commons.git
git clone https://github.com/servioticy/servioticy-api-private.git
git clone https://github.com/servioticy/servioticy-api-public.git
git clone https://github.com/servioticy/servioticy-datamodel.git
git clone https://github.com/servioticy/servioticy-dispatcher.git
git clone https://github.com/servioticy/servioticy-queue-client.git
git clone https://github.com/servioticy/servioticy-rest-client.git

git clone https://github.com/servioticy/servioticy-elasticsearch-indices.git
git clone https://github.com/servioticy/servioticy-brokers.git

cd ..

```

Now we are ready to run

`vagrant up --provision`

##Notes

- The script start Jetty on port `localhost:8082`, because most IDE already
provide a managed AS to debug and profile this should avoid port clashes.
- The provision script handles either the startup of the services, so use
`vagrant up --provision` at first run or call `/vagrant/provision.sh` inside the VM
to have services running

##TODO

- ensure libraries are up to date
- extract start scripts from install one
- sync start scripts with the ones avail in the VM
- include meta repositories and other sources
    - elasticsearch indices
    - brokers
    - other configurations avail in http://www.servioticy.com/?page_id=29
