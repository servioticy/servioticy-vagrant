//http://jmesnil.net/weblog/2013/09/25/stompjs-for-nodejs/
//http://jmesnil.net/stomp-websocket/doc/
var Stomp = require('stompjs');
var api = require('restler');

// Use raw TCP sockets
var client = Stomp.overTCP('localhost', 1883);
//var client = Stomp.overWS('ws://autonomic.ac.upc.edu/stomp', 61623);
// uncomment to print out the STOMP frames
//client.debug = console.log;

client.connect('compose', 'shines', function(frame) {
client.subscribe('/topic/*.from', function(message) {

        var request = JSON.parse(message.body);
        console.log("Going for a "+request.meta.method)
        console.log("Posted data "+JSON.stringify(request.body))
        api.json("http://localhost:8080"+request.meta.url,
//JSON.stringify(request),
                 request.body,
                 {headers: {'Content-Type': 'application/json', 'Authorization':request.meta.authorization}},
                 request.meta.method
        ).on('complete', function(data, response) {
                client.send('/topic/'+request.meta.authorization+".to",{},JSON.stringify(data))
                console.log("result: "+JSON.stringify(data))
        });
  });
});
