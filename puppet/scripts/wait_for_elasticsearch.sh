ELASTICSEARCH_LOG_FILE=/var/log/elasticsearch/serviolastic/serviolastic.log2
status=`grep -s started $ELASTICSEARCH_LOG_FILE | tail -1 | sed 's/ //g'`
while [ -z $status ]
do
	sleep 1
	status=`grep -s started $ELASTICSEARCH_LOG_FILE | tail -1 | sed 's/ //g'`
done

echo ElasticSearch service running
