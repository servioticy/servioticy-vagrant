#!/bin/bash

#. ../../scripts/env.sh
#http://docs.couchbase.com/couchbase-manual-2.2/#couchbase-admin-restapi-flushing-bucket
#curl -X POST -u admin:password -d flushEnabled=1  -d ramQuotaMB=200  http://localhost:8091/pools/default/buckets/actuations
curl -X POST 'http://admin:password@localhost:8091/pools/default/buckets/actuations/controller/doFlush'

