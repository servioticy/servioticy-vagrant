class { 'nginx': 
  service_ensure => 'stopped'
}

nginx::resource::vhost { 'localhost':
  www_root    => '/data/demo/map/app',
  listen_port => 8090,
  ssl         => false,
#  require     => Exec['prepare_map_demo']
} 

#exec {"stop_nginx":
#  require => [Package['couchbase-server']],
#  command => "/etc/init.d/nginx stop",
#}
