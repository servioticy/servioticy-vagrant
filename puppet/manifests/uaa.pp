vcsrepo { "/usr/src/cf-uaa":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => [ Package["git"], Class['maven::maven'], Package['oracle-java7-installer'], Package['curl'], Package['unzip'] ],
  source   => "git://github.com/cloudfoundry/uaa.git",
  revision => 'master',
} ->
yaml_setting { 'classname':
 target => '/usr/src/cf-uaa/uaa/src/main/resources/uaa.yml',
 key    => 'database/driverClassName',
 value  => 'com.mysql.jdbc.Driver', 
} ->
yaml_setting { 'url':
 target => '/usr/src/cf-uaa/uaa/src/main/resources/uaa.yml',
 key    => 'database/url',
 value  => 'jdbc:mysql://localhost:3306/uaadb',
} ->
yaml_setting { 'username':
 target => '/usr/src/cf-uaa/uaa/src/main/resources/uaa.yml',
 key    => 'database/username',
 value  => 'root',
} ->
yaml_setting { 'password':
 target => '/usr/src/cf-uaa/uaa/src/main/resources/uaa.yml',
 key    => 'database/password',
 value  => 'root',
} ->
yaml_setting { 'spring_profile':
 target => '/usr/src/cf-uaa/uaa/src/main/resources/uaa.yml',
 key    => 'spring_profiles',
 value  => 'mysql,default',
} ->
exec { "build-uaa":
    path => "/usr/local/bin/:/usr/bin:/bin/:/usr/src/cf-uaa:/opt/gradle-2.1/bin",
    cwd => "/usr/src/cf-uaa",
    require => [ Package['tomcat7'], Class['gradle'] ],
    command => "gradle :cloudfoundry-identity-uaa:war",
    user    => 'vagrant',
    group    => 'vagrant',    
} 




#database:
#   driverClassName: com.mysql.jdbc.Driver
#   url: jdbc:mysql://localhost:3306/uaadb
#   username: root
#   password: root