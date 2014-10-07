#!/bin/bash

CWD=/vagrant

#passwordless login to localhost
if [ ! -f "/home/vagrant/.ssh/id_dsa" ] ; then
  sudo -u vagrant ssh-keygen -t dsa -P '' -f /home/vagrant/.ssh/id_dsa
  sudo -u vagrant cat /home/vagrant/.ssh/id_dsa.pub >> /home/vagrant/.ssh/authorized_keys
  echo -e "Host *\n\t   StrictHostKeyChecking no\nUserKnownHostsFile=/dev/null\nLogLevel=quiet" > /home/vagrant/.ssh/config
  chown -R vagrant: /home/vagrant/.ssh #just in case
fi

if ! which puppet > /dev/null; then
  sed -i -e 's,http://[^ ]*,mirror://mirrors.ubuntu.com/mirrors.txt,' /etc/apt/sources.list
  wget http://apt.puppetlabs.com/puppetlabs-release-stable.deb -O /tmp/puppetlabs-release-stable.deb && \
    dpkg -i /tmp/puppetlabs-release-stable.deb && \
    apt-get update && \
    apt-get install puppet puppet-common hiera facter virt-what lsb-release -y --force-yes
fi

exit


source $CWD/config.sh

echo "*******************************************************"
echo "* Initial setup                                       *"
echo "*******************************************************"
$CWD/setup/prepare.sh

echo "*******************************************************"
echo "* Install mvn deps                                    *"
echo "*******************************************************"
$CWD/setup/install-mvn-deps.sh

echo "*******************************************************"
echo "* Installing Apollo MQ                                *"
echo "*******************************************************"
$CWD/setup/start-apollo.sh

#echo "*******************************************************"
#echo "* Glassfish                                           *"
#echo "*******************************************************"
#$CWD/setup/start-glassfish.sh

echo "*******************************************************"
echo "* Jetty                                               *"
echo "*******************************************************"
$CWD/setup/start-jetty.sh

echo "*******************************************************"
echo "* Couchbase                                           *"
echo "*******************************************************"
$CWD/setup/start-couchbase.sh

echo "*******************************************************"
echo "* Storm & Kestrel                                     *"
echo "*******************************************************"
$CWD/setup/start-storm.sh

echo "*******************************************************"
echo "* Elastic search                                      *"
echo "*******************************************************"
$CWD/setup/start-elasticsearch.sh

echo "*******************************************************"
echo "* Installing Servioticy                               *"
echo "*******************************************************"
$CWD/setup/start-servioticy.sh

