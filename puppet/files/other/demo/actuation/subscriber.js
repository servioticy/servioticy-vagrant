var Stomp = require('stompjs');
 
//process.argv.forEach(function (val, index, array) {
//  console.log(index + ': ' + val);
//});

var url="/topic/"+process.argv[2]+".actions";
console.log("subscription url: "+url);


// Use raw TCP sockets
//var client = Stomp.overTCP('api.servioticy.com', 1883);
var client = Stomp.overTCP('localhost', 1883);
// uncomment to print out the STOMP frames
//client.debug = console.log;
 
client.connect('compose', 'shines', function(frame) {
//client.subscribe('/topic/*.from', function(message) {
client.subscribe(url, function(message) {
 
        //var request = JSON.parse(message.body);
        //console.log("Posted data "+JSON.stringify(request.body))
        console.log(message.body)
  });
});
