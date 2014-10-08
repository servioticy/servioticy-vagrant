echo "Create External Cluster Reference"
echo "--------------------------------------------------------"

curl -v -u admin:password localhost:8091/pools/default/remoteClusters \
-d name=serviolastic \
-d hostname=localhost:9091 \
-d username=admin -d password=password


echo "Create Links"
echo "--------------------------------------------------------"

curl -v -X POST -u admin:password http://localhost:8091/controller/createReplication \
-d fromBucket=soupdates \
-d toCluster=serviolastic \
-d toBucket=soupdates \
-d replicationType=continuous

curl -v -X POST -u admin:password http://localhost:8091/controller/createReplication \
-d fromBucket=subscriptions \
-d toCluster=serviolastic \
-d toBucket=subscriptions \
-d replicationType=continuous



exit 0
