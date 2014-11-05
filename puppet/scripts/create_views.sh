#create views for service objects
curl -X PUT -H "Content-Type: application/json" http://admin:password@localhost:8092/serviceobjects/_design/user -d @byUser.ddoc &> /dev/null
curl -X PUT -H "Content-Type: application/json" http://admin:password@localhost:8092/serviceobjects/_design/index -d @byIndex.ddoc &> /dev/null
 

exit 0
