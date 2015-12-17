echo "Node initialization"
sleep 10
echo "--------------------------------------------------------"
/opt/couchbase/bin/couchbase-cli node-init \
    -c localhost --user=admin --password=password \
    --node-init-data-path=/data/couchbase

sleep 5
echo "Instance initialization"
echo "--------------------------------------------------------"
/opt/couchbase/bin/couchbase-cli cluster-init \
    -c localhost --user=admin --password=password \
    --cluster-init-username=admin \
    --cluster-init-password=password \
    --cluster-init-ramsize=1200
sleep 5

echo "Create buckets"
echo "--------------------------------------------------------"
/opt/couchbase/bin/couchbase-cli bucket-create \
    --bucket-type=couchbase \
    --bucket-ramsize=200 \
    --bucket-replica=1 \
    --bucket=serviceobjects \
    -c localhost --user=admin --password=password 

/opt/couchbase/bin/couchbase-cli bucket-create \
    --bucket-type=couchbase \
    --bucket-ramsize=200 \
    --bucket-replica=1 \
    --bucket=actuations \
     -c localhost --user=admin --password=password 

/opt/couchbase/bin/couchbase-cli bucket-create \
    --bucket-type=couchbase \
    --bucket-ramsize=200 \
    --bucket-replica=1 \
    --bucket=soupdates \
     -c localhost --user=admin --password=password 
     
/opt/couchbase/bin/couchbase-cli bucket-create \
    --bucket-type=couchbase \
    --bucket-ramsize=200 \
    --bucket-replica=1 \
    --bucket=subscriptions \
     -c localhost --user=admin --password=password 
     
/opt/couchbase/bin/couchbase-cli bucket-create \
    --bucket-type=couchbase \
    --bucket-ramsize=200 \
    --bucket-replica=1 \
    --bucket=reputation \
     -c localhost --user=admin --password=password 
     
exit 0
