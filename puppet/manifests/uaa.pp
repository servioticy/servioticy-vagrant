vcsrepo { "/usr/src/cf-uaa":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => [ Package["git"], Class['maven::maven'], Package['oracle-java7-installer'], Package['curl'], Package['unzip'] ],
  source   => "git://github.com/cloudfoundry/uaa.git",
  revision => 'master',
} ->
exec { "cf-uaa":
    path => "/usr/local/bin/:/usr/bin:/bin/:/usr/src/cf-uaa",
    cwd => "/usr/src/cf-uaa",
    command => "mvn install",
    user    => 'vagrant',
    group    => 'vagrant',
    require => Class['gradle']
} 

# mvn tomcat7:run -Dmaven.tomcat.port=8081

