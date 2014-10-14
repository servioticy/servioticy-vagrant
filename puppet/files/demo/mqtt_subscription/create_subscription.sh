API_TOKEN=`cat api_token.txt`
SO_ID=`cat SO.id`

curl -i -X POST -H "Content-Type: application/json" \
	-H "Authorization: $API_TOKEN" \
	-d '{"callback": "pubsub","destination": "'$API_TOKEN'"}' \
	http://localhost:8080/$SO_ID/streams/data/subscriptions

echo
