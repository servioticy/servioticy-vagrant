vcsrepo { "/usr/src/compose-idm":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => [ Package["git"], Class['maven::maven'], Package['oracle-java7-installer'], Package['curl'], Package['unzip'] ],
  source   => "https://github.com/nopobyte/compose-idm",
  revision => 'master',
} ->
file_line { 'change_idm_port':
  path  => '/usr/src/compose-idm/src/main/resources/application.properties',
  line  => 'server.port = 8082',
  match => '^server.port*',
} ->
exec { "compose-idm":
    path => "/usr/local/bin/:/usr/bin:/bin/:/usr/src/compose-idm:/opt/gradle-2.1/bin",
    cwd => "/usr/src/compose-idm",
    command => "sh compile_jar.sh",
    user    => 'vagrant',
    group    => 'vagrant',
    require => Class['gradle']
} 


#/opt/java/jdk1.7.0_45/bin/java -jar /opt/idm/COMPOSEIdentityManagement-0.5.0.jar