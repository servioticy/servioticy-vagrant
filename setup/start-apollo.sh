
source /vagrant/config.sh

cd $wd

if [ ! -d "$AP" ]; then

    echo "Installing Apollo MQ"
    echo "--------------------------------------------------------"

    if [ ! -f "$AP_filename" ]; then

        echo "Downloading Apelle"
        echo "--------------------------------------------------------"

        wget --quiet $AP_url
    fi;

   
#    apdir="${AP_filename%-*-*.*.*}"
    apdir=$AP_dirname
    tar xf $AP_filename -C $wd

    mv $wd/$apdir $AP

fi;


broker_vm="$wd/$servioticy_broker_name"

if [ ! -d $broker_vm ]; then
    cp -fr $servioticy_broker_source $broker_vm
fi;

echo "Starting up Apollo MQ"
echo "--------------------------------------------------------"


export APOLLO_BASE=$broker_vm
export APOLLO_HOME=$AP

cd $broker_vm

bin/apollo-broker run 2>&1 > $logdir/apollo.log &
sleep 20

exit 0