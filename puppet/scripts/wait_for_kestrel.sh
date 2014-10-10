echo Starting Kestrel service...
status=`grep -s started $KESTREL_STATUS_FILE | tail -1 | sed 's/ //g' | tail -1`
while [ -z $status ]
do
	sleep 1
	status=`grep -s started $KESTREL_STATUS_FILE | tail -1 | sed 's/ //g' | tail -1`
done

echo Kestrel service running
