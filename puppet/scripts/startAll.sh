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
sudo rm -f $KAFKA_LOG_FILE
rm -f $STORM_LOG_FILE
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

sudo /etc/init.d/elasticsearch-serviolastic start &> /dev/null
$SCRIPTS/wait_for_elasticsearch_up.sh
if [ ! -f /var/log/servioticy_initialized ];
then
	$SCRIPTS/create_index.sh &> /dev/null
fi

sudo /etc/init.d/couchbase-server start &> /dev/null
if [ ! -f /var/log/servioticy_initialized ];
then
	$SCRIPTS/wait_for_couchbase.sh 
	$SCRIPTS/create_buckets.sh &> /dev/null
	$SCRIPTS/wait_for_couchbase_up.sh
	$SCRIPTS/create_views.sh &> /dev/null
	$SCRIPTS/create_xdcr.sh &> /dev/null
fi
$SCRIPTS/wait_for_couchbase_up.sh

sudo /etc/init.d/zookeper start &> /dev/null
#$SCRIPTS/wait_for_zookeeper_up.sh

$KAFKA_HOME/bin/kafka-server-start.sh -daemon $KAFKA_HOME/config/server.properties &> /
if [ ! -f /var/log/servioticy_initialized ];
then
	$SCRIPTS/wait_for_kafka_up.sh
	$SCRIPTS/create_topics.sh
fi

sudo service mysql start &> /dev/null
$SCRIPTS/wait_for_mysql_up.sh
$SCRIPTS/create_database.sh &> /dev/null


sudo env JAVA_HOME=$JAVA_HOME /etc/init.d/tomcat7 start &> /dev/null
$SCRIPTS/wait_for_tomcat_up.sh

cd $IDM_HOME
$JAVA_HOME/bin/java -jar COMPOSEIdentityManagement-0.8.0.jar &> /dev/null &
$SCRIPTS/wait_for_IDM_up.sh

echo "Starting API (Jetty) service..."
sudo /etc/init.d/jetty start &> /dev/null
$SCRIPTS/wait_for_api.sh 

sudo $SERVIBROKER_HOME/bin/apollo-broker run &> /dev/null &
$SCRIPTS/wait_for_broker.sh 

cd $STORM_HOME
bin/storm jar $DISPATCHER_HOME/dispatcher-0.4.3-security-SNAPSHOT-jar-with-dependencies.jar com.servioticy.dispatcher.DispatcherTopology -f $DISPATCHER_HOME/dispatcher.xml -d &> $STORM_LOG_FILE &
$SCRIPTS/wait_for_storm.sh 

cd $BRIDGE_HOME
echo Starting MQTT-REST Bridge...
forever start -a -l /tmp/forever.log -o /tmp/bridge.js.out.log -e /tmp/bridge.js.err.log mqtt-and-stomp-bridge.js &> /dev/null
echo MQTT-REST Bridge running

cd $COMPOSER_HOME
echo Starting COMPOSER...
forever start -a -l /tmp/forever_red.log -o /tmp/nodered.js.out.log -e /tmp/nodered.js.err.log red.js &> /dev/null
echo COMPOSER running

#if [ ! -f /var/log/servioticy_initialized ];
#then
#	cd $DEMO_HOME/utils
#	sh create_all.sh
#	python generate_fake_data.py
#	cd $START_FOLDER
#fi

#echo Starting DEMO...
#sudo /etc/init.d/nginx start &> /dev/null
#echo DEMO running

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
