#!/bin/bash

export ROOT=/opt
export DATA=/data
export SCRIPTS=$ROOT/servioticy_scripts
export APOLLO_HOME=$ROOT/apache-apollo-1.7
export SERVIBROKER_HOME=$ROOT/servibroker
export BRIDGE_HOME=$ROOT/servioticy-bridge
export COMPOSER_HOME=$ROOT/servioticy-composer
export JAVA_HOME=/usr/lib/jvm/java-7-oracle
export COUCHBASE_HOME=$ROOT/couchbase
export KESTREL_HOME=$ROOT/kestrel-2.4.1
export STORM_HOME=$ROOT/apache-storm-0.9.2-incubating
export DISPATCHER_HOME=$ROOT/servioticy-dispatcher
export API_HOME=$ROOT/jetty
export USERDB_HOME=$DATA/userDB
export ELASTICSEARCH_HOME=$ROOT/elasticsearch
export DEMO_HOME=$DATA/demo/map

export CB_STATUS_FILE=/tmp/cb.status
export KESTREL_STATUS_FILE=/tmp/kestrel.log
export STORM_LOG_FILE=/tmp/storm.log
export BROKER_LOG_FILE=$SERVIBROKER_HOME/log/apollo.log
export API_LOG_FOLDER=$API_HOME/logs
export USERDB_STATUS_FILE=/tmp/userdb.status
export ELASTICSEARCH_LOG_FILE=/var/log/elasticsearch/serviolastic/serviolastic.log


#export PATH=$JAVA_HOME/bin:$PATH

