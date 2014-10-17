ELASTICSEARCH_LOG_FILE=/var/log/elasticsearch/serviolastic/serviolastic.log
status=`tail -10 $ELASTICSEARCH_LOG_FILE | grep -s started | tail -1 | sed 's/ //g'`
while [ -z $status ]
do
	sleep 1
	status=`tail -10 $ELASTICSEARCH_LOG_FILE | grep -s started | tail -1 | sed 's/ //g'`
done
