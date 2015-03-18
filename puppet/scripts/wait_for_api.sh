status=`/usr/bin/curl -X GET -s localhost:8080|grep 403| sed 's/ //g'`
while [ -z $status ]
do
	sleep 1
	status=`/usr/bin/curl -X GET -s localhost:8080|grep 403| sed 's/ //g'`
done
echo "API (Jetty) service running"

