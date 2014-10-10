echo Starting UserDB service...
rm -f $USERDB_STATUS_FILE
status=`grep -s 404 $USERDB_STATUS_FILE | sed 's/ //g' | tail -1`
while [ -z $status ]
do
	sleep 1
	curl -s -X GET http://localhost:5010 > $USERDB_STATUS_FILE
	status=`grep -s 404 $USERDB_STATUS_FILE | sed 's/ //g' | tail -1`
done
rm -f $USERDB_STATUS_FILE
echo UserDB service running
