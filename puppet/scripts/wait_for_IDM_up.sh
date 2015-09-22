echo Starting IDM service...
status=`grep -s "Tomcat started" $IDM_LOG_FILE | wc -l`
while [ $status -lt 1 ]
do
	sleep 1
	status=`grep -s "Tomcat started" $IDM_LOG_FILE | wc -l`
done
echo IDM service running
