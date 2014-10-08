echo "Node initialization"
echo "--------------------------------------------------------"

couchbase-cli node-init \
    -c localhost \
    --node-init-data-path=/data/couchbase

echo "Instance initialization"
echo "--------------------------------------------------------"
couchbase-cli cluster-init \
    -c localhost \
    --cluster-init-username=admin \
    --cluster-init-password=password \
    --cluster-init-ramsize=600

echo "Create buckets"
echo "--------------------------------------------------------"
couchbase-cli bucket-create \
    --bucket-type=couchbase \
    --bucket-ramsize=200 \
    --bucket-replica=1 \
    --bucket=serviceobjects \
    -c localhost --user=admin --password=password 

couchbase-cli bucket-create \
    --bucket-type=couchbase \
    --bucket-ramsize=200 \
    --bucket-replica=1 \
    --bucket=privatebucket \
     -c localhost --user=admin --password=password 

couchbase-cli bucket-create \
    --bucket-type=couchbase \
    --bucket-ramsize=200 \
    --bucket-replica=1 \
    --bucket=actuations \
     -c localhost --user=admin --password=password 

couchbase-cli bucket-create \
    --bucket-type=couchbase \
    --bucket-ramsize=200 \
    --bucket-replica=1 \
    --bucket=soupdates \
     -c localhost --user=admin --password=password 
     
couchbase-cli bucket-create \
    --bucket-type=couchbase \
    --bucket-ramsize=200 \
    --bucket-replica=1 \
    --bucket=subscriptions \
     -c localhost --user=admin --password=password 
     
     
#create views for service objects
curl -X PUT -H "Content-Type: application/json" http://admin:password@localhost:8092/serviceobjects/_design/user -d @../files/byUser.ddoc &> /dev/null
curl -X PUT -H "Content-Type: application/json" http://admin:password@localhost:8092/serviceobjects/_design/index -d @../files/byIndex.ddoc &> /dev/null
 

exit 0