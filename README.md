servioticy-vagrant
==================

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

- If you use Windows as your host system, note that you may encounter issues with the End-of-Line codification (CRLF in Windows vs LF in Unix/OSX). To avoid problems, use the following command in your git configuration (assuming you are not a developer committing code) before cloning this repository
`git config --global core.autocrlf false`


##Credits

This Vagrant box is a complete refactor on an initial version developed by Luca Capra at CREATE-NET.
The original version can be found at:

`https://github.com/muka/servioticy-vagrant`


#License

Apache2

Copyright 2014 Barcelona Supercomputing Center - Centro Nacional de Supercomputación (BSC-CNS)
Developed for COMPOSE project (compose-project.eu)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
