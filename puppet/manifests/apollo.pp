archive { 'apache-apollo-1.7':
  ensure => present,
  follow_redirects => true,
  checksum => false,
  url    => 'http://archive.apache.org/dist/activemq/activemq-apollo/1.7/apache-apollo-1.7-unix-distro.tar.gz',
  target => '/opt',
  src_target => '/home/vagrant/downloads',
  require  => [ Package["curl"], File['/home/vagrant/downloads/'] ],      
  timeout => 0
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

#exec { 'run_broker':
#    require => [ Package['oracle-java7-installer'], File['/opt/servibroker/etc/apollo.xml'], File['/opt/servibroker/etc/users.properties'], File['/opt/servibroker/etc/groups.properties']],
#    user    => 'vagrant',
#    group    => 'vagrant',
#    unless => "ps -fA | grep apollo | grep -v grep",          
#    cwd => "/opt/servibroker/bin/",
#    path => "/bin:/usr/bin/:/opt/servibroker/bin/",
#    command => "apollo-broker run &"
#}
