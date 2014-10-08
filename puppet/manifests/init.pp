include nodejs, wget, git, apt


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
}


apt::ppa { 'ppa:webupd8team/java': } ->
exec { 'apt-get update':
  path => '/usr/bin'
}

exec {
    'set-licence-selected':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';
 
    'set-licence-seen':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
}


package { ['libssl0.9.8', 'oracle-java7-installer']:
  ensure => present,
  require => Exec['apt-get update', 'set-licence-selected', 'set-licence-seen']
}


exec { "couchbase-server-source": 
  command => "/usr/bin/wget http://packages.couchbase.com/releases/2.2.0/couchbase-server-enterprise_2.2.0_x86_64_openssl098.deb",
  cwd => "/home/vagrant/downloads",
  creates => "/home/vagrant/downloads/couchbase-server-enterprise_2.2.0_x86_64_openssl098.deb",
  before => Package['couchbase-server']
}

package { "couchbase-server":
  provider => dpkg,
  ensure => installed,
  source => "/home/vagrant/downloads/couchbase-server-enterprise_2.2.0_x86_64_openssl098.deb"
} 

exec { "create_buckets":
    command => "sh /vagrant/puppet/files/create_buckets.sh",
    path    => "/bin:/opt/couchbase/bin/",
    require => Package['couchbase-server']
}



$init_hash = {
  'ES_USER' => 'elasticsearch',
  'ES_GROUP' => 'elasticsearch',
  'ES_HEAP_SIZE' => '2gb',
  'DATA_DIR' => '/data/elasticsearch',
}

class { 'elasticsearch':
  version => '1.0.1',
  #require => Class["java"],
  init_defaults => $init_hash 
}

$config_hash = {
  'cluster.name' => 'serviolastic',
  'couchbase.password' => 'password',
  'couchbase.username' => 'admin',
  'bootstrap.mlockall' => 'true',
  'node.name' => 'servinode'
}

elasticsearch::instance { 'serviolastic':
  config => $config_hash,
  datadir => '/data/elasticsearch'
}

elasticsearch::plugin{ 'transport-couchbase':
  module_dir => 'transport-couchbase',
  url        => 'http://packages.couchbase.com.s3.amazonaws.com/releases/elastic-search-adapter/1.3.0/elasticsearch-transport-couchbase-1.3.0.zip',
  instances  => 'serviolastic'
}

elasticsearch::plugin{ 'mobz/elasticsearch-head':
  module_dir => 'head',
  instances  => 'serviolastic'
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
  version => "3.0.5", # version to install
#  require => Class["java"]
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


class { 'jetty':
  version => "9.2.3.v20140905",
  home    => "/opt",
  user    => "vagrant",
  group   => "vagrant",
  require => Package["couchbase-server"]
}


file { '/opt/jetty/webapps/private.war':
          ensure => present,
          source => "/usr/src/servioticy/servioticy-api-private/target/api-private.war",
          notify  => Service["jetty"],
} ->
file { '/opt/jetty/webapps/root.war':
          ensure => present,
          source => "/usr/src/servioticy/servioticy-api-public/target/api-public.war",
          notify  => Service["jetty"],
}