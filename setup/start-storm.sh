
source /vagrant/config.sh

cd $wd;

#Install STORM
##IMPORTANT: This is a non-distributed installation of STORM for testing purposes! No need

if [ ! -d "$STORM" ]; then

    echo "Installing Storm"
    echo "--------------------------------------------------------"
    
        if [ ! -f "$wd/$STORM_filename" ]; then
            wget --quiet $STORM_url
        fi;
        
        # .tar.gz
        sdir="${STORM_filename%.*.*}"
        tar xzf $STORM_filename -C $wd
        mv $wd/$sdir $STORM
        cp $servioticy_dispatcher_xml $STORM
fi;

if [ ! -f "$KESTREL_jar" ]; then

    echo "Installing Kestrel"
    echo "--------------------------------------------------------"

    if [ ! -f "$wd/$KESTREL_filename" ]; then
        wget --quiet $KESTREL_url
    fi;

    rm -rf $KESTREL
    
    # .zip
    kdir="${KESTREL_filename%.*}"

    unzip $KESTREL_filename -d $wd
    mv $wd/$kdir $KESTREL

    cp $KESTREL_config $KESTREL/config


fi;


echo "Retrieving servioticy dispatcher"
echo "--------------------------------------------------------"
if [ ! -f $servioticy_dispatcher_jar ]; then
    cd $servioticy_dispatcher_source
    mvn clean compile assembly:single
fi;


echo "Starting Kestrel"
echo "--------------------------------------------------------"

rm -rf /tmp/kestrel-queue
rm -rf /tmp/kestrel.log

cd $KESTREL
java -server -Xmx1024m -Dstage=servioticy_queues -jar $KESTREL_jar 2>&1 > $logdir/kestrel.log &
sleep 40

echo "Starting Storm Topology"
echo "--------------------------------------------------------"

cd $STORM

#CP=$servioticy_dispatcher_jar
#for f in `ls $STORM/lib`
#do
#    CP="$CP:$STORM/lib/$f"
#done

bin/storm jar $servioticy_dispatcher_jar $servioticy_dispatcher_classname -f dispatcher.xml 2>&1 > $logdir/storm.log  &

