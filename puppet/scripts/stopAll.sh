#!/bin/bash

. /opt/servioticy_scripts/env.sh

echo Stopping servIoTicy services...
#Stop ALL
sudo /etc/init.d/jetty stop &> /dev/null
$KAFKA_HOME/bin/kafka-server-stop.sh &> /dev/null
sudo /etc/init.d/zookeeper stop &> /dev/null
sudo /etc/init.d/couchbase-server stop &> /dev/null
sudo /etc/init.d/elasticsearch-serviolastic stop &> /dev/null
sudo /etc/init.d/nginx stop &> /dev/null
sudo /etc/init.d/tomcat7 stop &> /dev/null
sudo service mysql stop &> /dev/null

forever stopall &> /dev/null

for pid in `ps -fA  | grep -e couchbase |grep -v grep | tr -s " " | tr -d "\t" | perl -pe "s/^[ ]//" | cut -d " "  -f 2`
do
        sudo kill -9 $pid &> /dev/null
	sudo wait $pid 2>/dev/null

done

for pid in `ps -fA  | grep java |grep -e storm -e jetty  -e tomcat -e COMPOSEIdentityManagement -e gradle | tr -s " " | tr -d "\t" | perl -pe "s/^[ ]//" | cut -d " "  -f 2`
do
        sudo kill -9 $pid &> /dev/null
	sudo wait $pid 2>/dev/null

done

for pid in `ps -fA  | grep -e apollo -e elasticsearch -e nodejs -e nginx| tr -s " " | tr -d "\t" | perl -pe "s/^[ ]//" | cut -d " "  -f 2`
do
        sudo kill -9 $pid &> /dev/null
	sudo wait $pid 2>/dev/null

done

sudo rm -f $COUCHBASE_HOME/var/lib/couchbase/logs/*
sudo rm -f $API_HOME/logs/*
sudo rm -f /var/log/elasticsearch/serviolastic/*
sudo rm -f $SERVIBROKER_HOME/log/*
sudo rm -f /var/log/tomcat7/*
sudo rm -rf /var/lib/tomcat7/webapps/uaa
sudo rm -rf $KAFKA_HOME/logs
sudo rm -rf /tmp/kafka-logs

echo Done.
