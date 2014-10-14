SUBS_ID=`cat SUBS1.id`
SUBS_ID2=`cat SUBS2.id`

curl -i -X GET -H "Content-Type: application/json" \
	http://localhost:8092/subscriptions/$SUBS_ID
echo

curl -i -X GET -H "Content-Type: application/json" \
	http://localhost:8092/subscriptions/$SUBS_ID2
echo

curl -i -X PUT -H "Content-Type: application/json" \
	-d @subscription1.json \
	http://localhost:8092/subscriptions/$SUBS_ID
echo

curl -i -X PUT -H "Content-Type: application/json" \
	-d @subscription2.json \
	http://localhost:8092/subscriptions/$SUBS_ID2
echo
