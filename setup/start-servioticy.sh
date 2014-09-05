
source /vagrant/config.sh


if [ ! -f $WAR_public ]; then

    echo "Packaging and deploy public api"
    echo "--------------------------------------------------------"

    cd servioticy_api_public
    mvn package

fi;

if [ ! -f $WAR_private ]; then

    echo "Packaging and deploy private api"
    echo "--------------------------------------------------------"

    cd servioticy_api_private
    mvn package

fi;


if [ ! -f "$JETTY/root.war" ]; then
    ln -s $WAR_public $JETTY/webapps/root.war
fi;

if [ ! -f "$JETTY/private.war" ]; then
    ln -s $WAR_private $JETTY/webapps/private.war
fi;