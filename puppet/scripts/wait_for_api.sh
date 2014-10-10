echo Starting API service...
status=`grep -s SelectChannelConnector $API_LOG_FOLDER/* | tail -1 | sed 's/ //g'`
while [ -z $status ]
do
	sleep 1
	status=`grep -s SelectChannelConnector $API_LOG_FOLDER/* | tail -1 | sed 's/ //g'`
done

echo REST API service running
