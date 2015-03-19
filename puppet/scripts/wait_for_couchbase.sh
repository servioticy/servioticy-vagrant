echo Initializing CouchBase Buckets, Views and XDCR...
CB_STATUS_FILE=/tmp/cb_status.txt
rm -f $CB_STATUS_FILE
curl -s -X GET http://localhost:8091/pools  > $CB_STATUS_FILE
status=`grep -s pools $CB_STATUS_FILE | sed 's/ //g' | tail -1`
while [ -z $status ]
do
	sleep 1
	curl -s -X GET http://localhost:8091/pools  > $CB_STATUS_FILE
	status=`grep -s pools $CB_STATUS_FILE | sed 's/ //g' | tail -1`
done
rm -f $CB_STATUS_FILE
echo CouchBase initialized
