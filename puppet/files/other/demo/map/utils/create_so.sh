SO_ID=`cat SO.id`
SO_ID2=`cat SO2.id`

curl -i -X GET -H "Content-Type: application/json" \
	http://localhost:8092/serviceobjects/$SO_ID
echo

curl -i -X GET -H "Content-Type: application/json" \
	http://localhost:8092/serviceobjects/$SO_ID2
echo

curl -i -X PUT -H "Content-Type: application/json" \
	-d @so.json \
	http://localhost:8092/serviceobjects/$SO_ID
echo

curl -i -X PUT -H "Content-Type: application/json" \
	-d @so2.json \
	http://localhost:8092/serviceobjects/$SO_ID2
echo
