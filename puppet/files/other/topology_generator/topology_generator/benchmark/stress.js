/**
 * Created by alvaro on 27/03/14.
 */
var benchrest = require('bench-rest');
var fs = require('fs');
var RNG = require('rng');

var rng = new RNG('SEED TEXT');

var initial_streams = JSON.parse(fs.readFileSync('../streams.json', 'utf8'));
var isl = initial_streams.length;

var urlgenerator = function () {
    var isl = initial_streams.length;
    var index = rng.range(0, isl);

    if (index < 0) {
        index = 0;
    }
    else if (index >= isl) {
        index = isl - 1;
    }
    return 'http://172.20.11.1:8080/' + initial_streams[index][0] + '/streams/' + initial_streams[index][1];
};

var out_json = function () {
    return  {"channels": {"channel0": {"current-value": 1}}, "lastUpdate": new Date().getTime()}
}

var flow = {
    before: [],      // operations to do before anything
    beforeMain: [],  // operations to do before each iteration
    main: [  // the main flow for each iteration, #{INDEX} is unique iteration counter token
        { put: urlgenerator, headers: {"Content-Type": "application/json", "Authorization": "MWRiODFmZjAtMWQyYS00MDQ0LTg1ZDQtZGE2NzVkMGYwNDYzOGM2YjE1NTUtZmNjNi00MGYyLWI4NTEtNzdiMjQxMDZhZWEz"}, json: out_json }
    ],
    afterMain: [
    ],   // operations to do after each iteration
    after: []        // operations to do after everything is done
};
var runOptions = {
    limit: 1,         // concurrent connections
    iterations: 1,  // number of iterations to perform
    prealloc: 100      // only preallocate up to 100 before starting
};
var errors = [];
benchrest(flow, runOptions)
    .on('error', function (err, ctxName) {
        console.error('Failed in %s with err: ', ctxName, err);
    })
    .on('progress', function (stats, percent, concurrent, ips) {
        console.log('Progress: %s complete', percent);
    })
    .on('end', function (stats, errorCount) {

        console.log('error count: ', errorCount);
        console.log('stats', stats);
    });