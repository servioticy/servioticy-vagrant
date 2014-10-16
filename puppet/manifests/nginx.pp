class { 'nginx': }

nginx::resource::vhost { 'localhost':
  www_root    => '/data/demo/map/app',
  listen_port => 8090,
  ssl         => false,
  require     => Exec['prepare_map_demo']
}