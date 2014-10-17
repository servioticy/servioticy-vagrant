echo Starting MQTT Broker...
status=`grep -s available $BROKER_LOG_FILE |tail -1|grep available | sed 's/ //g'`
while [ -z $status ]
do
	sleep 1
	status=`grep -s available $BROKER_LOG_FILE |tail -1|grep available | sed 's/ //g'`
done

echo MQTT Broker running
