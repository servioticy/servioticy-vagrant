SO_ID=`cat SO.id`

curl -i -X GET -H "Content-Type: application/json" \
	http://localhost:8092/serviceobjects/$SO_ID
echo

curl -i -X PUT -H "Content-Type: application/json" \
	-d @reset_so.json \
	http://localhost:8092/serviceobjects/$SO_ID
echo
