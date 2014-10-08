echo "Create External Cluster Reference"
echo "--------------------------------------------------------"

curl -v -u admin:password localhost:8091/pools/default/remoteClusters \
-d name=serviolastic \
-d hostname=localhost:9091 \
-d username=admin -d password=password


echo "Create Links"
echo "--------------------------------------------------------"

curl -v -X POST -u admin:password http://localhost:8091/controller/createReplication \
-d uuid=9eee38236f3bf28406920213d93981a3 \
-d fromBucket=beer-sample \
-d toCluster=remote1 \
-d toBucket=remote_beer \
-d replicationType=continuous


exit 0