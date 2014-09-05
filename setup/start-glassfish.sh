
source /vagrant/config.sh

cd $wd;

if [ ! -d "$GF" ]; then

    echo "Installing Glassfish AS"
    echo "--------------------------------------------------------"
    wget $glassfish_url > /dev/null 2>&1
    unzip $glassfish_filename > /dev/null
fi;

echo "Starting Glassfish AS"
echo "--------------------------------------------------------"

cd $GF/bin

sudo ./asadmin start-domain
