
source /vagrant/config.sh

cd $wd;

J=$JETTY

if [ ! -d "$J" ]; then

    echo "Installing Jetty AS"
    echo "--------------------------------------------------------"

    if [ ! -f "$jetty_filename" ]; then
        wget  $jetty_url -O $jetty_filename
    fi;
    
    bname="${jetty_filename%.*.*}"
    tar xf $jetty_filename -C $wd
    
    mv $bname $J

fi;

echo "Starting Jetty AS"
echo "--------------------------------------------------------"

cd $J


rm -rf $JETTY/webapps/*

export JETTY_HOME=$J
bin/jetty.sh start

