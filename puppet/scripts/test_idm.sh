curl --digest -u "composecontroller:composecontrollerpassword" \
     -H "Content-Type: application/json;charset=UTF-8" \
     -d '{"username":"compobsc","password":"bsccompo"}' \
     http://localhost:8082/idm/user/
     
curl -H "Content-Type: application/json;charset=UTF-8" \
     -d '{"username":"compobsc","password":"bsccompo"}' \
     -X POST http://localhost:8082/auth/user/