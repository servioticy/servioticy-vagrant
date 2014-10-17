#!/bin/bash
. env.sh

echo Starting servIoTicy services...
echo "*******************************"

sudo /etc/init.d/couchbase-server start &> /dev/null
$SCRIPTS/wait_for_couchbase_up.sh 

sudo rm -f $BROKER_LOG_FILE
sudo $SERVIBROKER_HOME/bin/apollo-broker run &> /dev/null &
$SCRIPTS/wait_for_broker.sh 

cd $KESTREL_HOME
rm -f $KESTREL_STATUS_FILE
$JAVA_HOME/bin/java -server -Xmx1024m -Dstage=servioticy_queues -jar kestrel_2.9.2-2.4.1.jar &> /dev/null &
$SCRIPTS/wait_for_kestrel.sh 

cd $STORM_HOME
rm -f $STORM_LOG_FILE
bin/storm jar $DISPATCHER_HOME/dispatcher-0.2.1-jar-with-dependencies.jar com.servioticy.dispatcher.DispatcherTopology -f $DISPATCHER_HOME/dispatcher.xml &> $STORM_LOG_FILE &
#$SCRIPTS/wait_for_storm.sh 

cd $USERDB_HOME
python userDB.py &> /dev/null &
$SCRIPTS/wait_for_userDB.sh

sudo rm -rf $API_LOG_FOLDER/*
sudo $API_HOME/bin/jetty.sh start &> /dev/null
$SCRIPTS/wait_for_api.sh 

sudo rm -f $ELASTICSEARCH_LOG_FILE
sudo /etc/init.d/elasticsearch-serviolastic start &> /dev/null
$SCRIPTS/wait_for_elasticsearch_up.sh

cd $BRIDGE_HOME
echo Starting MQTT-REST Bridge...
forever start -a -l /tmp/forever.log -o /tmp/bridge.js.out.log -e /tmp/bridge.js.err.log mqtt-and-stomp-bridge.js &> /dev/null
echo MQTT-REST Bridge running

cd $COMPOSER_HOME
echo Starting COMPOSER...
forever start -a -l /tmp/forever_red.log -o /tmp/nodered.js.out.log -e /tmp/nodered.js.err.log red.js &> /dev/null
echo COMPOSER running


echo "*******************************"
echo sevIoTicy is now running.
