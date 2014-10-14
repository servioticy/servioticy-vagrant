API_TOKEN=`cat api_token.txt`
SO_ID=`cat SO.id`
SO_ID2=`cat SO2.id`
CSO_ID=`cat CSO.id`
curl -i -X DELETE -H "Content-Type: application/json" \
	-H "Authorization: $API_TOKEN" \
	http://localhost:8080/$SO_ID/streams/data

curl -i -X DELETE -H "Content-Type: application/json" \
	-H "Authorization: $API_TOKEN" \
	http://localhost:8080/$SO_ID2/streams/data

curl -i -X DELETE -H "Content-Type: application/json" \
	-H "Authorization: $API_TOKEN" \
	http://localhost:8080/$CSO_ID/streams/fahrenheit

curl -i -X DELETE -H "Content-Type: application/json" \
	-H "Authorization: $API_TOKEN" \
	http://localhost:8080/$CSO_ID/streams/aboveSeventy

echo
