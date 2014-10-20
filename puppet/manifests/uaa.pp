vcsrepo { "/usr/src/cf-uaa":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => [ Package["git"], Class['maven::maven'], Package['oracle-java7-installer'], Package['curl'], Package['unzip'] ],
  source   => "git://github.com/cloudfoundry/uaa.git",
  revision => 'master',
} ->
exec { "build-uaa":
    path => "/usr/local/bin/:/usr/bin:/bin/:/usr/src/cf-uaa",
    cwd => "/usr/src/cf-uaa",
    require => [ Package['tomcat7'], Class['gradle'] ],
    command => "gradle :cloudfoundry-identity-uaa:war",
    user    => 'vagrant',
    group    => 'vagrant',    
} 