echo Starting MQTT Broker...
status=`grep -s longer $BROKER_LOG_FILE |grep longer | sed 's/ //g'`
while [ -z $status ]
do
	sleep 1
	status=`grep -s longer $BROKER_LOG_FILE |grep longer | sed 's/ //g'`
done

echo MQTT Broker running
