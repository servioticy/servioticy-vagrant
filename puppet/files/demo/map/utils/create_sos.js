var couchbase = require("couchbase");
var fs = require('fs');
var so1 = require("./so.json");
var so2 = require("./so2.json");
var cso = require("./cso.json");

// Connect to Couchbase Server

var cluster = new couchbase.Cluster('127.0.0.1:8091');
var bucket = cluster.openBucket('serviceobjects', function(err) {
  if (err) {
    throw err;
  }
  bucket.upsert(fs.readFileSync("./SO.id","utf8").replace(/(\r\n|\n|\r)/gm,""), JSON.stringify(so1), function(err, result) {
    if (err) {
      throw err;
    }
      console.log(result);
  });
  bucket.upsert(fs.readFileSync("./SO2.id","utf8").replace(/(\r\n|\n|\r)/gm,""), JSON.stringify(so2), function(err, result) {
    if (err) {
      throw err;
    }

      console.log(result);
  });
  bucket.upsert(fs.readFileSync("./CSO.id","utf8").replace(/(\r\n|\n|\r)/gm,""), JSON.stringify(cso), function(err, result) {
    if (err) {
      throw err;
    }
      console.log(result); 
      process.exit();
  });
});

