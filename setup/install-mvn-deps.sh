
source /vagrant/config.sh


echo "Checking libs availability"
echo "--------------------------------------------------------"

for prj in servioticy-datamodel servioticy-api-commons servioticy-rest-client servioticy-queue-client
do

    bpath=$servioticy_source/$prj
    
    pkg_name=$(perl -e '$_ = join "", <>; m!<project[^>]*>.*\n(?:    |\t)<artifactId[^>]*>\s*([^<]+?)\s*</artifactId>.*</project>!s and print "$1\n"' $bpath/pom.xml)
    pkg_version=$(perl -e '$_ = join "", <>; m!<project[^>]*>.*\n(?:    |\t)<version[^>]*>\s*([^<]+?)\s*</version>.*</project>!s and print "$1\n"' $bpath/pom.xml)

    jar="$pkg_name.jar"
    jar_with_version="$pkg_name-$pkg_version.jar"
    jar_wit_deps="$pkg_name-$pkg_version-with-dependencies.jar"
    
    jar_bpath="$bpath/target";

    if [ ! -e $jar_bpath/$jar ] && [ ! -e $jar_bpath/$jar_with_version ] && [ ! -e $jar_bpath/$jar_with_deps ]; then

        echo "Compiling $prj"
        echo "--------------------------------------------------------"
        
        cd $servioticy_source/$prj
        mvn clean install

    fi;
done
 