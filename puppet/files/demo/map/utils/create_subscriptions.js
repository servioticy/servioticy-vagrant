var couchbase = require("couchbase");
var fs = require('fs');
var subs1 = require("./subscription1.json");
var subs2 = require("./subscription2.json");

// Connect to Couchbase Server

var cluster = new couchbase.Cluster('127.0.0.1:8091');

var bucket2 = cluster.openBucket('subscriptions', function(err) {
  if (err) {
    throw err;
  }
  bucket2.upsert(fs.readFileSync("./SUBS1.id","utf8").replace(/(\r\n|\n|\r)/gm,""), JSON.stringify(subs1), function(err, result) {
    if (err) {
      throw err;
    }
      console.log(result);

  });
  bucket2.upsert(fs.readFileSync("./SUBS2.id","utf8").replace(/(\r\n|\n|\r)/gm,""), JSON.stringify(subs2), function(err, result) {
    if (err) {
      throw err;
    }
      console.log(result);
      process.exit();
  });
});
