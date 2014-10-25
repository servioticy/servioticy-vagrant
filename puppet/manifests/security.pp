vcsrepo { "/usr/src/compose-idm":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => [ Package["git"], Class['gradle'], Package['oracle-java7-installer'], Package['curl'], Package['unzip'] ],
  source   => "https://github.com/nopobyte/compose-idm",
  revision => 'master',
} ->
file_line { 'change_idm_port':
  path  => '/usr/src/compose-idm/src/main/resources/application.properties',
  line  => 'server.port = 8082',
  match => '^server.port*',
  before => [ Exec['compose-idm'], File['/usr/src/compose-idm/src/main/resources/uaa.properties'] ]
} 

vcsrepo { "/usr/src/compose-pdp":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => [ Package["git"], Class['gradle'], Package['oracle-java7-installer'], Package['curl'], Package['unzip'] ],
  source   => "https://github.com/nopbyte/servioticy-pdp",
  revision => 'master',
  before   => [ Exec['compose-pdp'] ] 
} 



exec { "compose-idm":
    path => "/usr/local/bin/:/usr/bin:/bin/:/usr/src/compose-idm:/opt/gradle-2.1/bin",
    cwd => "/usr/src/compose-idm",
    command => "sh compile_jar.sh",
    user    => 'vagrant',
    group    => 'vagrant',
    require => [ Class['gradle'], File['/usr/src/compose-idm/src/main/resources/uaa.properties'] ]
} 

exec { "compose-pdp":
    path => "/usr/local/bin/:/usr/bin:/bin/:/usr/src/compose-pdp:/opt/gradle-2.1/bin",
    cwd => "/usr/src/compose-pdp",
    command => "gradle clean build install -x test",
    user    => 'vagrant',
    group    => 'vagrant',
    require => [ Class['gradle'] ]
} ->
exec { "install-pdp":
    path => "/usr/local/bin/:/usr/bin:/bin/",
    cwd => "/usr/src/compose-pdp/build/libs",
    command => "mvn install:install-file -Dfile=PDPComponentServioticy-0.1.0.jar -DgroupId=de.passau.uni -DartifactId=servioticy-pdp -Dversion=0.1.0 -Dpackaging=jar",
    user    => 'vagrant',
    group    => 'vagrant',
    before   => Exec['build_servioticy'],
    require  => Class['maven::maven'], 
}
