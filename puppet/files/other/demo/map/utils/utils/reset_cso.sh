CSO_ID=`cat CSO.id`

curl -i -X GET -H "Content-Type: application/json" \
	http://localhost:8092/serviceobjects/$CSO_ID
echo

curl -i -X PUT -H "Content-Type: application/json" \
	-d @reset_cso.json \
	http://localhost:8092/serviceobjects/$CSO_ID
echo
