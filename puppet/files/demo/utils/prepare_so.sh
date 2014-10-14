SO_ID=`cat SO.id`

curl -i -X PUT -H "Content-Type: application/json" \
	-d @so_description.json \
	http://localhost:8092/serviceobjects/$SO_ID
echo
