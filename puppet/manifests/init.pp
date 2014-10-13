include wget, git, apt

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin/" ] }

lvm::volume { 'data':
  ensure => present,
  vg     => 'data',
  pv     => '/dev/sdb',
  fstype => 'ext4',
  size   => '1G',
}->
fstab { 'A test fstab entry':
  source => '/dev/sdb1',
  dest   => '/data',
  type   => 'ext4',
  before => File['/data/couchbase']
}

file { '/home/vagrant/downloads/':
  ensure => 'directory',
}

file { '/data':
  ensure => 'directory',
}

file { '/data/couchbase':
  ensure => 'directory',
  owner => "couchbase",
  group => "couchbase",
  require => Package['couchbase-server']
}

file { '/home/vagrant/LICENSE.txt':
          ensure => present,
          replace => true,
          owner    => 'vagrant',
          group    => 'vagrant',          
          source => "/vagrant/puppet/files/other/LICENSE.txt",
}

file { '/home/vagrant/README.txt':
          ensure => present,
          replace => true,
          owner    => 'vagrant',
          group    => 'vagrant',          
          source => "/vagrant/puppet/files/other/README.txt",
}

file { '/home/vagrant/README.demos.txt':
          ensure => present,
          replace => true,
          owner    => 'vagrant',
          group    => 'vagrant',          
          source => "/vagrant/puppet/files/other/README.demos.txt",
}

file { '/home/vagrant/VERSION.txt':
          ensure => present,
          replace => true,
          owner    => 'vagrant',
          group    => 'vagrant',          
          source => "/vagrant/puppet/files/other/VERSION.txt",
}



apt::ppa { 'ppa:webupd8team/java': 
            before => Exec['apt-get update']
}
apt::ppa { 'ppa:chris-lea/node.js': 
            before => Exec['apt-get update']
}

exec { 'apt-get update':
  path => '/usr/bin'
}

exec {
    'set-licence-selected':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';
 
    'set-licence-seen':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
}

package { 'forever':
  ensure   => present,
  provider => 'npm',
  require => [Package['nodejs']]
}

package { 'stompjs':
  ensure   => present,
  provider => 'npm',
  require => [Package['nodejs']]
}

package { ['libssl0.9.8', 'oracle-java7-installer', 'curl', 'nodejs', 'unzip']:
  ensure => present,
  require => Exec['apt-get update', 'set-licence-selected', 'set-licence-seen']
}


archive { 'apache-storm-0.9.1':
  ensure => present,
  follow_redirects => true,
  checksum => false,
  url    => 'http://ftp.cixug.es/apache/incubator/storm/apache-storm-0.9.1-incubating/apache-storm-0.9.1-incubating.tar.gz',
  target => '/opt',
  src_target => '/home/vagrant/downloads',
  require  => [ Package["curl"], File['/home/vagrant/downloads/'] ],
} ->
file { '/opt/servioticy-dispatcher':
          ensure => 'directory',
          owner => 'vagrant',
          group => 'vagrant'
} ->
file { '/opt/servioticy-dispatcher/dispatcher-0.2.1-jar-with-dependencies.jar':
          ensure => present,
          source => "/usr/src/servioticy/servioticy-dispatcher/target/dispatcher-0.2.1-jar-with-dependencies.jar",
          require => [Exec['build_servioticy'],File['/opt/servioticy-dispatcher']],
          owner => 'vagrant',
          group => 'vagrant'
}

archive { 'kestrel-2.4.1':
  ensure => present,
  follow_redirects => true,
  extension => "zip",
  checksum => false,
  url    => 'http://twitter.github.io/kestrel/download/kestrel-2.4.1.zip',
  target => '/opt',
  src_target => '/home/vagrant/downloads',
  require  => [ Package["curl"], Package["unzip"], File['/home/vagrant/downloads/'] ],
} ->
file { '/opt/kestrel-2.4.1':
  owner    => 'vagrant',
  group    => 'vagrant'
} ->
file { '/opt/kestrel-2.4.1/config/servioticy_queues.scala':
          ensure => present,
          source => "/vagrant/puppet/files/servioticy_queues.scala",
          owner    => 'vagrant',
          group    => 'vagrant',
} ->
exec { "run_kestrel":
    command => "java -server -Xmx1024m -Dstage=servioticy_queues -jar /opt/kestrel-2.4.1/kestrel_2.9.2-2.4.1.jar &",
    cwd     => "/opt/kestrel-2.4.1",
    require => Package['oracle-java7-installer'] ,
    user    => 'vagrant',
    group    => 'vagrant',
    unless => "ps -fA | grep kestrel | grep -v grep",
}

wget::fetch { "couchbase-server-source":
  source      => 'http://packages.couchbase.com/releases/2.2.0/couchbase-server-enterprise_2.2.0_x86_64_openssl098.deb',
  destination => '/home/vagrant/downloads/couchbase-server-enterprise_2.2.0_x86_64_openssl098.deb',
  timeout     => 0,
  verbose     => false,
  require     => File['/home/vagrant/downloads/']
} ->
package { "couchbase-server":
  provider => dpkg,
  ensure => installed,
  source => "/home/vagrant/downloads/couchbase-server-enterprise_2.2.0_x86_64_openssl098.deb"
} ->
exec { "create_buckets":
    command => "/bin/sh create_buckets.sh",
    cwd     => "/vagrant/puppet/files",
    path    => "/bin:/usr/bin/:/opt/couchbase/bin/",
    #logoutput => true,
    require => Package['couchbase-server']
}

$init_hash = {
  'ES_USER' => 'elasticsearch',
  'ES_GROUP' => 'elasticsearch',
  'ES_HEAP_SIZE' => '1g',
  'DATA_DIR' => '/data/elasticsearch',
}

class { 'elasticsearch':
  package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.1.deb',
  init_defaults => $init_hash 
}

$config_hash = {
  'cluster.name' => 'serviolastic',
  'couchbase.password' => 'password',
  'couchbase.username' => 'admin',
  'couchbase.maxConcurrentRequests' => '1024',
  'bootstrap.mlockall' => 'true',
  'node.name' => 'servinode',
  'network.publish_host' => '127.0.0.1',
  'discovery.zen.ping.multicast.enabled' => 'false',
  'discovery.zen.ping.unicast.hosts' => '["127.0.0.1"]'
}

elasticsearch::instance { 'serviolastic':
  config => $config_hash,
  datadir => '/data/elasticsearch'
} ->
vcsrepo { "/opt/servioticy-indices":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => [ Package["git"] ],
  source   => "https://github.com/servioticy/servioticy-elasticsearch-indices.git",
  revision => 'master'
} ->
exec {
    'create-indices':
      command => 'sleep 10 && /bin/sh create_soupdates.sh; /bin/sh create_subscriptions.sh',
      cwd => "/opt/servioticy-indices",
      path =>  "/usr/local/bin/:/bin/:/usr/bin/"    
} ->
exec {
    'create-xdcr':
      command => '/bin/sh create_xdcr.sh',
      cwd => "/vagrant/puppet/files",
      path =>  "/usr/local/bin/:/bin/:/usr/bin/",      
      require => Exec['create_buckets']    
}


elasticsearch::plugin{ 'transport-couchbase':
  module_dir => 'transport-couchbase',
  url        => 'http://packages.couchbase.com.s3.amazonaws.com/releases/elastic-search-adapter/1.3.0/elasticsearch-transport-couchbase-1.3.0.zip',
  instances  => 'serviolastic',
  require  => [ Package["git"] ],
}

elasticsearch::plugin{ 'mobz/elasticsearch-head':
  module_dir => 'head',
  instances  => 'serviolastic',
  require  => [ Package["git"] ],
}




vcsrepo { "/usr/src/servioticy":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => [ Package["git"] ],
  source   => "https://github.com/servioticy/servioticy.git",
  revision => 'master',
} ->
class { "maven::maven":
  version => "3.2.2", # version to install
} ->
 # Setup a .mavenrc file for the specified user
maven::environment { 'maven-env' : 
    user => 'vagrant',
    # anything to add to MAVEN_OPTS in ~/.mavenrc
    maven_opts => '-Xmx1384m',       # anything to add to MAVEN_OPTS in ~/.mavenrc
    maven_path_additions => "",      # anything to add to the PATH in ~/.mavenrc
} -> 
exec { "build_servioticy":
   cwd     => "/usr/src/servioticy",
   command => "mvn -Dmaven.test.skip=true package",
   path    => "/usr/local/bin/:/usr/bin:/bin/",
   user    => 'vagrant'
} 



file { '/opt/jetty/webapps/private.war':
          ensure => present,
          source => "/usr/src/servioticy/servioticy-api-private/target/api-private.war",
          notify  => Service["jetty"],
          require => Exec['build_servioticy']
}

file { '/opt/jetty/webapps/root.war':
          ensure => present,
          source => "/usr/src/servioticy/servioticy-api-public/target/api-public.war",
          notify  => Service["jetty"],
          require => Exec['build_servioticy']
}

class { 'jetty':
  version => "9.2.3.v20140905",
  home    => "/opt",
  user    => "vagrant",
  group   => "vagrant",
  require => Package["couchbase-server"]
}

file_line { 'cross_origin':
   path => '/opt/jetty/start.ini',
   line => '--module=servlets',
   notify  => Service["jetty"],
}

vcsrepo { "/opt/servioticy-bridge":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => [ Package["git"], Package['forever'] ],
  source   => "https://github.com/servioticy/servioticy-brokers.git",
  revision => 'master'
} ->
exec { "run_bridge":
  command => "forever start -a --sourceDir /opt/servioticy-bridge -l /tmp/forever_bridge.log -o /tmp/bridge.js.out.log -e /tmp/bridge.js.err.log mqtt-and-stomp-bridge.js",
  path    => "/bin:/usr/local/bin/:/usr/bin/",
  require => [Package['forever'], Package['stompjs']],
  unless  => "forever list | grep bridge"
}


vcsrepo { "/opt/servioticy-composer":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => [ Package["git"], Package['forever'] ],
  source   => "https://github.com/servioticy/servioticy-composer.git",
  revision => 'master',
} ->
exec { "run_composer":
  command => "forever start -a --sourceDir /opt/servioticy-composer -l /tmp/forever_red.log -o /tmp/nodered.js.out.log -e /tmp/nodered.js.err.log red.js",
  path    => "/bin:/usr/local/bin/:/usr/bin/",
  require => [Package['forever']],
  unless  => "forever list | grep forever_red"
}



archive { 'apache-apollo-1.7':
  ensure => present,
  follow_redirects => true,
  checksum => false,
  url    => 'http://ftp.cixug.es/apache/activemq/activemq-apollo/1.7/apache-apollo-1.7-unix-distro.tar.gz',
  target => '/opt',
  src_target => '/home/vagrant/downloads',
  require  => [ Package["curl"], File['/home/vagrant/downloads/'] ],      
} ->
file { '/opt/apache-apollo-1.7':
  owner    => 'vagrant',
  group    => 'vagrant',          
  
} ->
exec { 'create_broker':
  require => [ Package['oracle-java7-installer'] ],
  creates => '/opt/servibroker',
  cwd => "/opt/apache-apollo-1.7/bin/",
  path => "/bin:/usr/bin/:/opt/apache-apollo-1.7/bin/",
  command => "apollo create /opt/servibroker",
  #logoutput => true,
} ->
file { '/opt/servibroker':
  owner    => 'vagrant',
  group    => 'vagrant',  
  before   => [File['/opt/servibroker/etc/apollo.xml'], File['/opt/servibroker/etc/users.properties'], File['/opt/servibroker/etc/groups.properties']]  
} 

file { '/opt/servibroker/etc/apollo.xml':
          ensure => present,
          replace => true,
          owner    => 'vagrant',
          group    => 'vagrant',          
          source => "/vagrant/puppet/files/apollo.xml",
          require => Exec['create_broker']
}

file { '/opt/servibroker/etc/users.properties':
          ensure => present,
          replace => true,
          owner    => 'vagrant',
          group    => 'vagrant',          
          source => "/vagrant/puppet/files/users.properties",
          require => Exec['create_broker']
}

file { '/opt/servibroker/etc/groups.properties':
          ensure => present,
          replace => true,
          owner    => 'vagrant',
          group    => 'vagrant',          
          source => "/vagrant/puppet/files/groups.properties",
          require => Exec['create_broker']
}

exec { 'run_broker':
    require => [ Package['oracle-java7-installer'], File['/opt/servibroker/etc/apollo.xml'], File['/opt/servibroker/etc/users.properties'], File['/opt/servibroker/etc/groups.properties']],
    user    => 'vagrant',
    group    => 'vagrant',
    unless => "ps -fA | grep apollo | grep -v grep",          
    cwd => "/opt/servibroker/bin/",
    path => "/bin:/usr/bin/:/opt/servibroker/bin/",
    command => "apollo-broker run &"
}


class { 'python' :
    version    => 'system',
    pip        => true,
    dev        => false,
    virtualenv => true,
    gunicorn   => false,
    before     => Exec['run_userDB']
}

python::pip { 'Flask' :
    pkgname       => 'Flask',
}

file { '/data/userDB':
          ensure => directory,
          replace => true,
          owner    => 'vagrant',
          group    => 'vagrant',          
          source => "/vagrant/puppet/files/userDB",
          recurse => remote,
          before     => Exec['run_userDB']
}

exec { 'run_userDB':
    require => [ Package['python-pip'], File['/data/userDB']],
    user    => 'vagrant',
    group    => 'vagrant',
    unless => "ps -fA | grep userDB | grep -v grep",          
    cwd => "/data/userDB/",
    path => "/bin:/usr/bin/",
    command => "python userDB.py &"
}