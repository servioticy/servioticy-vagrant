#!/bin/bash
. /opt/servioticy_scripts/env.sh

START_FOLDER=$PWD

echo
echo "*******************************"
echo Starting servIoTicy services...
echo "*******************************"
echo


sudo rm -f $ELASTICSEARCH_LOG_FILE
sudo rm -rf $API_LOG_FOLDER/*
sudo rm -f $BROKER_LOG_FILE
rm -f $STORM_LOG_FILE
rm -f $KESTREL_STATUS_FILE
sleep 5

if [ ! -f /var/log/servioticy_initialized ];
then
        echo
        echo "**********************************************"
        echo "***** FIRST TIME THAT YOU RUN SERVIOTICY *****"
        echo "*****      INTIALIZING COMPONENTS        *****"
        echo "**********************************************"
        echo
fi

cd $SCRIPTS
sudo /etc/init.d/elasticsearch-serviolastic start &> /dev/null
$SCRIPTS/wait_for_elasticsearch_up.sh
if [ ! -f /var/log/servioticy_initialized ];
then
        $SCRIPTS/create_index.sh &> /dev/null
fi

sudo /etc/init.d/couchbase-server start &> /dev/null
$SCRIPTS/wait_for_couchbase.sh 
if [ ! -f /var/log/servioticy_initialized ];
then
        $SCRIPTS/create_buckets.sh &> /dev/null
        $SCRIPTS/wait_for_couchbase_up.sh
        $SCRIPTS/create_xdcr.sh &> /dev/null
else
        $SCRIPTS/create_views.sh &> /dev/null
fi
$SCRIPTS/wait_for_couchbase_up.sh

echo "Starting Zookeeper..."
sudo service zookeeper start &> /dev/null
#$SCRIPTS/wait_for_zookeeper_up.sh
sleep 5
echo "Zookeeper running..."

cd $USERDB_HOME
python userDB.py &> /dev/null &
$SCRIPTS/wait_for_userDB.sh

sudo service kafka start &> /dev/null
$SCRIPTS/wait_for_kafka_up.sh

$SCRIPTS/create_topics.sh

echo "Starting API (Jetty) service..."
sudo /etc/init.d/jetty start &> /dev/null
$SCRIPTS/wait_for_api.sh 

sudo $SERVIBROKER_HOME/bin/apollo-broker run &> /dev/null &
$SCRIPTS/wait_for_broker.sh 

cd $STORM_HOME
bin/storm jar $DISPATCHER_HOME/dispatcher-0.4.3-SNAPSHOT-jar-with-dependencies.jar com.servioticy.dispatcher.DispatcherTopology -f $DISPATCHER_HOME/dispatcher.xml -d &> $STORM_LOG_FILE &
$SCRIPTS/wait_for_storm.sh 

cd $BRIDGE_HOME
echo Starting MQTT-REST Bridge...
forever start -a -l /tmp/forever.log -o /tmp/bridge.js.out.log -e /tmp/bridge.js.err.log mqtt-and-stomp-bridge.js &> /dev/null
echo MQTT-REST Bridge running

#cd $COMPOSER_HOME
#echo Starting COMPOSER...
#forever start -a -l /tmp/forever_red.log -o /tmp/nodered.js.out.log -e /tmp/nodered.js.err.log red.js &> /dev/null
#echo COMPOSER running

#if [ ! -f /var/log/servioticy_initialized ];
#then
#        cd $DEMO_HOME/utils
#        sh create_all.sh &> /dev/null
#        python generate_fake_data.py &> /dev/null
#        cd $START_FOLDER
#fi

echo Starting DEMO...
sudo /etc/init.d/nginx start &> /dev/null
echo DEMO running

if [ ! -f /var/log/servioticy_initialized ];
then
        sudo touch /var/log/servioticy_initialized

        echo
        echo "*********************************"
        echo    sevIoTicy is now initialized
        echo      but needs to be restarted
        echo      to get all changes applied
        echo 
        echo Please run 'stop-servioticy' and 
        echo  then 'start-servioticy' again
        echo "*********************************"
        echo

        nohup stop-servioticy &> /dev/null &

else

        echo
        echo "*******************************"
        echo sevIoTicy is now running.
        echo "*******************************"
        echo

fi
