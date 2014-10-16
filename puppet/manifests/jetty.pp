class { 'jetty':
  version => "9.2.3.v20140905",
  home    => "/opt",
  user    => "vagrant",
  group   => "vagrant",
  require => [Package["couchbase-server"]]
}

file { '/opt/jetty/start.ini':
  ensure => 'present',
  audit  => 'all',
} -> 
file_line { 'cross_origin':
   path => '/opt/jetty/start.ini',
   line => '--module=servlets',
   notify  => Service["jetty"],
}