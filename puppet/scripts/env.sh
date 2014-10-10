#!/bin/bash

export ROOT=/home/servioticy
export SCRIPTS=$ROOT/scripts
export SERVIOTICY_HOME=$ROOT/servioticy
export BROKER_HOME=$ROOT/broker
export APOLLO_HOME=$BROKER_HOME/apache-apollo-1.7
export SERVIBROKER_HOME=$BROKER_HOME/servibroker
export BRIDGE_HOME=$BROKER_HOME/bridge
export JAVA_HOME=$SERVIOTICY_HOME/java
export COUCHBASE_HOME=$SERVIOTICY_HOME/couchbase/opt/couchbase
export KESTREL_HOME=$SERVIOTICY_HOME/kestrel
export STORM_HOME=$SERVIOTICY_HOME/storm
export DISPATCHER_HOME=$SERVIOTICY_HOME/servioticy_dispatcher
export DISPATCHER_WITH_TOPOLOGY_LOGGING_HOME=$ROOT/topology_generator
export API_HOME=$SERVIOTICY_HOME/api
export USERDB_HOME=$SERVIOTICY_HOME/userDB
export ELASTICSEARCH_HOME=$SERVIOTICY_HOME/elasticsearch


export CB_STATUS_FILE=/tmp/cb.status
export KESTREL_STATUS_FILE=/tmp/kestrel.log
export STORM_LOG_FILE=/tmp/storm.log
export BROKER_LOG_FILE=$SERVIBROKER_HOME/log/apollo.log
export API_LOG_FOLDER=$API_HOME/logs
export USERDB_STATUS_FILE=/tmp/userdb.status
export ELASTICSEARCH_LOG_FILE=$ELASTICSEARCH_HOME/logs/serviolastic.log


export PATH=$JAVA_HOME/bin:$PATH

