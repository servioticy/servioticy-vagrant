#!/bin/bash

. env.sh

echo Stopping servIoTicy services...
#Stop ALL
sudo /etc/init.d/couchbase-server stop &> /dev/null

sudo $API_HOME/bin/jetty.sh stop &> /dev/null
sudo /etc/init.d/elasticsearch-serviolastic stop &> /dev/null

forever stopall &> /dev/null

for pid in `ps -fA  | grep couchbase |grep -v grep | tr -s " " | tr -d "\t" | perl -pe "s/^[ ]//" | cut -d " "  -f 2`
do
        sudo kill -9 $pid &> /dev/null

done

for pid in `ps -fA  | grep java |grep -e kestrel -e storm -e jetty | tr -s " " | tr -d "\t" | perl -pe "s/^[ ]//" | cut -d " "  -f 2`
do
        sudo kill -9 $pid &> /dev/null

done

for pid in `ps -fA  | grep -e userDB.py -e apollo -e elasticsearch -e nodejs| tr -s " " | tr -d "\t" | perl -pe "s/^[ ]//" | cut -d " "  -f 2`
do
        sudo kill -9 $pid &> /dev/null

done

sudo rm -f $COUCHBASE_HOME/var/lib/couchbase/logs/*
sudo rm -f $API_HOME/logs/*
sudo rm -f  /var/log/elasticsearch/serviolastic/*
sudo rm -f $SERVIBROKER_HOME/log/*

echo Done.
