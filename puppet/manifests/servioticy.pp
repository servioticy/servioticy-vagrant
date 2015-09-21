#exec {"wait for api":
#  require => [Package['couchbase-server'],Package['curl'],Service["jetty"], File['/opt/servioticy_scripts']],
#  command => "/bin/sh /opt/servioticy_scripts/wait_for_api.sh",
#}

vcsrepo { "/usr/src/servioticy":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => [ Package["git"] ],
  source   => "https://github.com/servioticy/servioticy.git",
  revision => 'kafka-security',
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
exec { "build_rhinomod":
   cwd     => "/usr/src/servioticy/servioticy-dispatcher",
   command => "bash unmanaged-dependencies.sh",
   path    => "/usr/local/bin/:/usr/bin:/bin/:/usr/src/servioticy/servioticy-dispatcher",
   user    => 'vagrant',
   require => Package['ant'],
   timeout => 0
} -> 
exec { "build_servioticy":
   cwd     => "/usr/src/servioticy",
   command => "git submodule update --init --recursive; mvn -Dmaven.test.skip=true package",
   path    => "/usr/local/bin/:/usr/bin:/bin/",
   user    => 'vagrant',
   timeout => 0
} 

