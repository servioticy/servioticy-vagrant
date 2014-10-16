exec {"wait for api":
  require => [Package['couchbase-server'],Service["jetty"], File['/opt/servioticy_scripts']],
  command => "/usr/bin/wget --spider --tries 50 --retry-connrefused --no-check-certificate -q http://localhost:8080",
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
