
source /vagrant/config.sh

cd $wd;

if [ ! -d "$ES" ]; then

    echo "Installing Elastic Search"
    echo "--------------------------------------------------------"
    
        if [ ! -f "$wd/$ES_filename" ]; then
            wget --quiet $ES_url
        fi;
        
        esdir="${ES_filename%.*.*}"
        tar xf $ES_filename -C $wd
        mv $esdir $ES
fi;

echo "Starting Elastic Search"
echo "--------------------------------------------------------"

cd $ES

./bin/elasticsearch 2>&1 > $logdir/elasticsearch.log &
sleep 20

