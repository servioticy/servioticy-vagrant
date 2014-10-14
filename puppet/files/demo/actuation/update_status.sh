API_TOKEN=`cat api_token.txt`
SO_ID=`cat SO.id`

curl -i -X PUT -H "Content-Type: application/json" \
	-H "Authorization: $API_TOKEN" \
	-d 'Received on the device' \
	http://localhost:8080/$SO_ID/actuations/$1

echo
