class { 'zookeeper':
  servers => ['127.0.0.1'],
  client_ip => $::ipaddress_lo
}
