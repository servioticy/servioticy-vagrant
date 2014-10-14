API_TOKEN=`cat api_token.txt`
SO_ID=`cat SO.id`

curl -i -X GET -H "Content-Type: application/json" \
	-H "Authorization: $API_TOKEN" \
	http://localhost:8080/$SO_ID/actuations/$1

echo
