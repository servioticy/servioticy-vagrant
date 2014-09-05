
# install directory
wd=/home/vagrant/compose

logdir="$wd/logs"

# in setup/* files this files is sourced 
#from static path /vagrant/config.sh!
provision=/vagrant

# java api codebase
servioticy_source="$provision/servioticy"

#java soruce for dispatcher
servioticy_dispatcher_source="$servioticy_source/servioticy-dispatcher"

# jar location
servioticy_dispatcher_jar="$servioticy_dispatcher_source/target/dispatcher-0.2.0-jar-with-dependencies.jar"
servioticy_dispatcher_classname="com.servioticy.dispatcher.DispatcherTopology"

# dispatcher.xml location
servioticy_dispatcher_xml="$provision/dispatcher.xml"

# APIs location
servioticy_api_private="$servioticy_source/servioticy-api-private"
servioticy_api_public="$servioticy_source/servioticy-api-public"

#WAR locations
WAR_public=$servioticy_api_public/target/api-public.war
WAR_private=$servioticy_api_private/target/api-private.war

# Apache apollo virtual host home (APOLLO_HOME)
# will be copied from /vagrant on provision
servioticy_broker_name="servibroker"

# source dir to install locally
servioticy_broker_source="$provision/broker/$servioticy_broker_name"

# jetty

JETTY="$wd/jetty"
jetty_filename="jetty-distribution-8.1.15.v20140411.tar.gz"
jetty_url="http://eclipse.org/downloads/download.php?file=/jetty/stable-8/dist/${jetty_filename}&r=1"

#glassfish

glassfish_filename="glassfish-4.0.zip"
glassfish_url="http://download.java.net/glassfish/4.0/release/$glassfish_filename";

GF_domain=domain1
GF="$wd/glassfish4"
asadmin=$GF/bin/asadmin

# couchbase

COUCHBASE_filename="couchbase-server-enterprise_2.2.0_x86_64_openssl098.deb"
COUCHBASE_url="http://packages.couchbase.com/releases/2.2.0/$COUCHBASE_filename"


COUCHBASE_installdir="$wd/couchbase"
COUCHBASE="$COUCHBASE_installdir/opt/couchbase"

COUCHBASE_wait=10

COUCHBASE_host="localhost"
COUCHBASE_admin="admin"
COUCHBASE_password="password"

COUCHBASE_BASEURL="http://${COUCHBASE_admin}:${COUCHBASE_password}@${COUCHBASE_host}:8092"

COUCHBASE_bucket_so="serviceobjects"
COUCHBASE_bucket_private="privatebucket"

#storm

STORM="$wd/storm"

STORM_filename="apache-storm-0.9.1-incubating.tar.gz"
STORM_url="http://apache.rediris.es/incubator/storm/apache-storm-0.9.1-incubating/$STORM_filename"

KESTREL="$wd/kestrel"

KESTREL_filename="kestrel-2.4.1.zip"
KESTREL_url="http://twitter.github.io/kestrel/download/$KESTREL_filename"

KESTREL_config="$provision/servioticy_queues.scala"
KESTREL_jar="kestrel_2.9.2-2.4.1.jar"

# Elastic Search

ES="$wd/elasticsearch"

ES_filename="elasticsearch-1.2.0.tar.gz"
ES_url="https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_filename"

#Apollo

AP="$wd/apollo"

AP_filename="apache-apollo-1.7-unix-distro.tar.gz"
AP_dirname="apache-apollo-1.7"
AP_url="http://apache.fis.uniroma2.it/activemq/activemq-apollo/1.7/$AP_filename"
