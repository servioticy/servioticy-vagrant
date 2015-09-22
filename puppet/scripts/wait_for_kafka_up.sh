echo Starting kafka service...
sleep 2
status=`grep -s started $KAFKA_LOG_FILE | tail -1 | sed 's/ //g'`
while [ -z $status ]
do
	sleep 1
	status=`grep -s started $KAFKA_LOG_FILE | tail -1 | sed 's/ //g'`
done
echo Kafka service running
