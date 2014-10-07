file { '/home/vagrant/downloads/':
  ensure => 'directory',
}

include nodejs, wget, git

exec { "couchbase-server-source": 
  command => "/usr/bin/wget http://packages.couchbase.com/releases/2.2.0/couchbase-server-enterprise_2.2.0_x86_64_openssl098.deb",
  cwd => "/home/vagrant/downloads",
  creates => "/home/vagrant/downloads/couchbase-server-enterprise_2.2.0_x86_64_openssl098.deb",
  before => Package['couchbase-server']
}

exec { "install-deps":
  command => "/usr/bin/apt-get install libssl0.9.8",
  before => Package['couchbase-server']
}

class { 'java':
  distribution => 'jdk',
}


package { "couchbase-server":
  provider => dpkg,
  ensure => installed,
  source => "/home/vagrant/downloads/couchbase-server-enterprise_2.2.0_x86_64_openssl098.deb"
}



class { 'elasticsearch':
  package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.1.deb',
  config => { 'cluster.name' => 'serviolastic' }
  
}


elasticsearch::instance { 'servioticy':
  config => { 'node.name' => 'servinode' },
  datadir => '/home/vagrant/elasticsearch-data',
  init_defaults => {
    'ES_HEAP_SIZE' => '2gb'
  }
}


class { 'jetty':
  version => "9.2.3.v20140905",
  home    => "/opt",
  user    => "jetty",
  group   => "jetty",
}


git::repo{'servioticy':
 path   => '/usr/src/servioticy',
 source => 'https://github.com/servioticy/servioticy.git',
 branch => 'master'
}


 # Install Maven
class { "maven::maven":
  version => "3.0.5", # version to install
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
