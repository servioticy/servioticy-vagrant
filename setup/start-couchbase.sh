
source /vagrant/config.sh

cd $wd

if [ ! -d "$COUCHBASE" ]; then

    if [ -d "$COUCHBASE_installdir" ]; then
        rm -r "$COUCHBASE_installdir"
    fi;

    echo "Installing Couchbase"
    echo "--------------------------------------------------------"

    # root directory
    mkdir $COUCHBASE_installdir

    # download CouchBase (2.2.0+ required) (This case is using couchbase for 64-bit Ubuntu 10.04)
    # requires libssl.so
    # sudo apt-get install libssl0.9.8
    if [ ! -f "$COUCHBASE_filename" ]; then

        echo "Downloading Couchbase - $COUCHBASE_url"
        echo "--------------------------------------------------------"

        wget --quiet $COUCHBASE_url > /dev/null 2>&1
    fi;

    dpkg-deb -x $COUCHBASE_filename $COUCHBASE_installdir

    # Couchbase folder
    cd $COUCHBASE
    
    export LC_ALL="en_US.UTF-8"

    echo "Setting paths"
    echo "--------------------------------------------------------"    
    ./bin/install/reloc.sh `pwd`

    echo "Start server"
    echo "--------------------------------------------------------"
    ./bin/couchbase-server -- -noinput -detached
    

    echo "Wait $COUCHBASE_wait sec for startup"
    echo "--------------------------------------------------------"
    sleep $COUCHBASE_wait

    echo "Instance initialization"
    echo "--------------------------------------------------------"
#    bin/couchbase-cli node-init -c $COUCHBASE_host --node-init-data-path=/tmp 
    bin/couchbase-cli cluster-init \
        -c $COUCHBASE_host \
        --cluster-init-username=$COUCHBASE_admin \
        --cluster-init-password=$COUCHBASE_password \
        --cluster-init-ramsize=600


    echo "Create buckets"
    echo "--------------------------------------------------------"
    ./bin/couchbase-cli bucket-create \
        --bucket-type=couchbase \
        --bucket-ramsize=200 \
        --bucket-replica=1 \
        --bucket=$COUCHBASE_bucket_so \
        -c $COUCHBASE_host -u $COUCHBASE_admin -p $COUCHBASE_password

    ./bin/couchbase-cli bucket-create \
        --bucket-type=couchbase \
        --bucket-ramsize=200 \
        --bucket-replica=1 \
        --bucket=$COUCHBASE_bucket_private \
        -c $COUCHBASE_host -u $COUCHBASE_admin -p $COUCHBASE_password



    echo "{\"views\":{\"byUser\":{\"map\":\"function (doc, meta) {\n emit(meta.id, null);\n } \"}}}" > "$wd/tmp-byUser.ddoc"

    echo "Create views"
    echo "--------------------------------------------------------"

    public_url="$COUCHBASE_BASEURL/$COUCHBASE_bucket_so/_design/user"
    private_url="$COUCHBASE_BASEURL/$COUCHBASE_bucket_private/_design/user"

    echo "Public view url $public_url"
    echo "Private view url $private_url"

    curl -X PUT -H "Content-Type: application/json" $public_url  -d "@$wd/tmp-byUser.ddoc" 
    curl -X PUT -H "Content-Type: application/json" $private_url -d "@$wd/tmp-byUser.ddoc"

    rm "$wd/tmp-byUser.ddoc"

else

    cd $COUCHBASE

    if [ ! `ps aux | grep couchbase | grep root | awk '{print $2;}' > /dev/null &2>1` ]; then
#        echo "Stop server"
#        echo "--------------------------------------------------------"
#        bin/couchbase-server -k

#        echo "Wait $COUCHBASE_wait sec for stopping"
#        echo "--------------------------------------------------------"
#        sleep $COUCHBASE_wait

        echo "Start server"
        echo "--------------------------------------------------------"
        bin/couchbase-server -- -noinput -detached 2>&1 > $logdir/couchbase.log

    fi;

#    echo "Wait $COUCHBASE_wait sec for startup"
#    echo "--------------------------------------------------------"
#    sleep $COUCHBASE_wait


fi;


exit 0