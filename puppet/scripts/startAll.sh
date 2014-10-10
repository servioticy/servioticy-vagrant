#!/bin/bash
. scripts/env.sh

echo Starting servIoTicy services...
echo "*******************************"

cd $COUCHBASE_HOME
bin/couchbase-server -- -noinput -detached &> /dev/null
$SCRIPTS/wait_for_couchbase.sh 

rm -f $BROKER_LOG_FILE
$SERVIBROKER_HOME/bin/apollo-broker run &> /dev/null &
$SCRIPTS/wait_for_broker.sh 

cd $KESTREL_HOME
rm -f $KESTREL_STATUS_FILE
$JAVA_HOME/bin/java -server -Xmx1024m -Dstage=servioticy_queues -jar kestrel_2.9.2-2.4.1.jar &> /dev/null &
$SCRIPTS/wait_for_kestrel.sh 

cd $STORM_HOME
rm -f $STORM_LOG_FILE
bin/storm jar $DISPATCHER_HOME/dispatcher-0.2.1-jar-with-dependencies.jar com.servioticy.dispatcher.DispatcherTopology -f $DISPATCHER_HOME/dispatcher.xml &> $STORM_LOG_FILE &
#bin/storm jar $DISPATCHER_HOME/dispatcher-0.1-jar-with-dependencies.jar com.servioticy.dispatcher.DispatcherTopology -f $DISPATCHER_HOME/dispatcher.xml -d &> $STORM_LOG_FILE &
$SCRIPTS/wait_for_storm.sh 

cd $USERDB_HOME
python userDB.py &> /dev/null &
$SCRIPTS/wait_for_userDB.sh

cd $ELASTICSEARCH_HOME
rm -f $ELASTICSEARCH_LOG_FILE
bin/elasticsearch &>/dev/null &
$SCRIPTS/wait_for_elasticsearch.sh

cd $API_HOME
rm -rf $API_LOG_FOLDER/*
$JAVA_HOME/bin/java -jar servioticy_api.jar &> /dev/null &
$SCRIPTS/wait_for_api.sh 

cd $BRIDGE_HOME
echo Starting MQTT-REST Bridge...
forever start -a -l /tmp/forever.log -o /tmp/bridge.js.out.log -e /tmp/bridge.js.err.log bridge.js &> /dev/null
echo MQTT-REST Bridge running


echo "*******************************"
echo sevIoTicy is now running.
