echo Starting IDM service...
#rm -f $UAA_STATUS_FILE
#status=`grep -s healthy $CB_STATUS_FILE | sed 's/ //g' | tail -1`
#while [ -z $status ]
#do
#	sleep 1
#	curl -s -X GET http://localhost:8091/pools/default | grep status > $CB_STATUS_FILE
#	status=`grep -s healthy $CB_STATUS_FILE | sed 's/ //g' | tail -1`
#done
#rm -f $CB_STATUS_FILE
echo IDM service running
