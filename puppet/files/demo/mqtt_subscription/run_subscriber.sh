API_TOKEN=`cat api_token.txt`
SO_ID=`cat SO.id`

node subscriber.js $API_TOKEN $SO_ID data
