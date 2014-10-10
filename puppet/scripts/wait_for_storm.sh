echo Starting STORM service...
status=`grep -s finished $STORM_LOG_FILE | sed 's/ //g' | tail -1 `
while [ -z $status ]
do
	sleep 1
	status=`grep -s finished $STORM_LOG_FILE | sed 's/ //g' | tail -1`
done

echo STORM service running
