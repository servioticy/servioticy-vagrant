exec {"wait for api":
  require => [Package['couchbase-server'],Package['curl'],Service["jetty"], File['/opt/servioticy_scripts']],
  command => "/bin/sh /opt/servioticy_scripts/wait_for_api.sh",
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
  version => "3.2.2", # version to install
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

exec{ 'prepare_map_demo':
    user    => 'vagrant',
    group    => 'vagrant',
    cwd => "/data/demo/map/utils",
    path => "/bin:/usr/bin/",
    command => "sh create_all.sh; python generate_fake_data.py",
    require => [ Package['python-pip'], File['/data/demo'], Package['couchbase-server'],  Package['couchbase'], Exec['create-xdcr'], Exec['wait for api'], Exec['run_kestrel'], Exec['run_storm'] ],
}


exec{ 'stop_all':
    user    => 'vagrant',
    group    => 'vagrant',
    cwd => "/opt/servioticy_scripts",
    path => "/bin:/usr/bin/:/opt/servioticy_scripts",
    command => "sh stopAll.sh; sh stopAll.sh",
    require => [ Exec['prepare_map_demo'], Exec['build-uaa'] ],
}

file_line { 'motd0':
   path => '/etc/motd.tail',
   line => '*********************************************************',
} ->
file_line { 'motd1':
   path => '/etc/motd.tail',
   line => 'Welcome to servIoTicy Virtual Appliance',
} ->
file_line { 'motd2':
   path => '/etc/motd.tail',
   line => " * You can run 'start-servioticy' and 'stop-servioticy' to start and stop all the services",
} ->
file_line { 'motd3':
   path => '/etc/motd.tail',
   line => "Enjoy!",
}->
file_line { 'motd4':
   path => '/etc/motd.tail',
   line => '*********************************************************',
   before => Exec['stop_all']
}