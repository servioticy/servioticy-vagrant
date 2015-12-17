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

file { '/opt/apache-storm-0.9.6/logback/cluster.xml':
         ensure => present,
         replace => true,
         owner    => 'vagrant',
         group    => 'vagrant',          
         source => "/vagrant/puppet/files/cluster.xml",
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

file { '/opt/servioticy-dispatcher':
          ensure => 'directory',
          owner => 'vagrant',
          group => 'vagrant'
} 

file { '/opt/servioticy-dispatcher/dispatcher-0.4.3-SNAPSHOT-jar-with-dependencies.jar':
          ensure => present,
          source => "/usr/src/servioticy/servioticy-dispatcher/target/dispatcher-0.4.3-SNAPSHOT-jar-with-dependencies.jar",
          require => [File['/opt/servioticy-dispatcher'],Exec['build_servioticy'],File['/opt/servioticy-dispatcher']],
          owner => 'vagrant',
          group => 'vagrant'
}

file { '/opt/servioticy-dispatcher/dispatcher.xml':
          ensure => present,
          source => "/vagrant/puppet/files/dispatcher.xml",
          require => [File['/opt/servioticy-dispatcher'], Exec['build_servioticy'],File['/opt/servioticy-dispatcher']],
          owner => 'vagrant',
          group => 'vagrant'
}

file { '/data/demo':
          ensure => directory,
          replace => true,
          owner    => 'vagrant',
          group    => 'vagrant',          
          source => "/vagrant/puppet/files/demo",
          recurse => remote
}


file { '/opt/servioticy_scripts':
          ensure => directory,
          replace => true,
          owner    => 'vagrant',
          group    => 'vagrant',          
          source => "/vagrant/puppet/scripts",
          recurse => remote
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

file { '/usr/bin/start-servioticy':
   ensure => 'link',
   target => '/opt/servioticy_scripts/startAll.sh',
   require => File['/opt/servioticy_scripts'],
   mode => 755
}

file { '/usr/bin/stop-servioticy':
   ensure => 'link',
   target => '/opt/servioticy_scripts/stopAll.sh',
   require => File['/opt/servioticy_scripts'],
   mode => 755
}

file { '/home/vagrant/.bash_aliases':
   ensure => 'link',
   target => '/vagrant/puppet/scripts/env.sh',
}

file { '/tmp/mysql-server.response':
         ensure => present,
         source => "/vagrant/puppet/files/mysql-server.response",
}

