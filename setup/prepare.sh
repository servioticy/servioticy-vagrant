
source /vagrant/config.sh

if [ -d "$wd" ]; then
    
    echo "Skipping preparation"
    echo "--------------------------------------------------------"
    exit 0;

fi;

echo "Creating $wd"
echo "--------------------------------------------------------"
if [ ! -d "$wd" ]; then
    mkdir -p $wd
    mkdir -p $logdir
fi

echo "Installing packages"
echo "--------------------------------------------------------"

# clean up package status
sudo dpkg --configure -a

sudo apt-get install -y  python-software-properties 2>&1 > $logdir/prepare.log

sudo apt-add-repository ppa:webupd8team/java -y 2>&1 > $logdir/prepare.log

#sudo apt-get upgrade -y > /dev/null

sudo apt-get update > /dev/null 2>&1

echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

sudo apt-get install -y oracle-java7-set-default \
    git-core maven2 unzip \
    libssl0.9.8 \
    2>&1 >> $logdir/prepare.log



