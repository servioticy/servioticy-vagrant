
rm /tmp/userinfo.txt

response=$(curl --digest -u "composecontroller:composecontrollerpassword" \
     -H "Content-Type: application/json;charset=UTF-8" \
     -d '{"username":"demo","password":"demo"}' \
     --write-out %{http_code} -s \
     -o /tmp/userinfo.txt \
     http://localhost:8082/idm/user/)


  if [ $response != 201 ];
     then
                echo -n "Error registering IDM user...  -> "
		cat /tmp/userinfo.txt
		echo
     else

                echo "Successfully registered IDM user (user: demo, pass: demo)"
     fi
