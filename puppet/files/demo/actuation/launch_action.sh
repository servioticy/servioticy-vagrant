API_TOKEN=`cat api_token.txt`
SO_ID=`cat SO.id`

#curl -i -X POST -H "Content-Type: application/json" \
curl -i -X POST -H "Content-Type: text/plain" \
	-H "Authorization: $API_TOKEN" \
	-d '{"param1": "foo","param2": "more foo"}' \
	http://localhost:8080/$SO_ID/actuations/reboot

echo
