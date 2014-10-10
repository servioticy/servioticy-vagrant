#!/bin/bash

. scripts/env.sh

echo Stopping servIoTicy services...
#Stop ALL
cd $COUCHBASE_HOME
bin/couchbase-server -k

for pid in `ps -fA  | grep couchbase |grep -v grep | tr -s " " | tr -d "\t" | perl -pe "s/^[ ]//" | cut -d " "  -f 2`
do
        kill -9 $pid &> /dev/null

done

for pid in `ps -fA  | grep java |grep -e kestrel -e storm -e servioticy_api | tr -s " " | tr -d "\t" | perl -pe "s/^[ ]//" | cut -d " "  -f 2`
do
        kill -9 $pid &> /dev/null

done

for pid in `ps -fA  | grep -e userDB.py -e apollo -e elasticsearch | tr -s " " | tr -d "\t" | perl -pe "s/^[ ]//" | cut -d " "  -f 2`
do
        kill -9 $pid &> /dev/null

done


forever stopall &> /dev/null

rm -f /home/servioticy/servioticy/couchbase/opt/couchbase/var/lib/couchbase/logs/*
rm -f /home/servioticy/servioticy/api/logs/*
rm -f /home/servioticy/servioticy/elasticsearch/logs/*
rm -f /home/servioticy/broker/servibroker/log/*
rm -rf /tmp/*

echo Done.
