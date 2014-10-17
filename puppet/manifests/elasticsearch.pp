exec {"wait for elasticsearch":
  require => [Elasticsearch::Instance['serviolastic'], File['/opt/servioticy_scripts']],
  command => "/bin/sh /opt/servioticy_scripts/wait_for_elasticsearch.sh",
  timeout => 0
}

$init_hash = {
  'ES_USER' => 'elasticsearch',
  'ES_GROUP' => 'elasticsearch',
  'ES_HEAP_SIZE' => '1g',
  'DATA_DIR' => '/data/elasticsearch',
}

class { 'elasticsearch':
  package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.4.deb',
  init_defaults => $init_hash,
  require => Package['oracle-java7-installer'] ,
}

$config_hash = {
  'cluster.name' => 'serviolastic',
  'couchbase.password' => 'password',
  'couchbase.username' => 'admin',
  'couchbase.maxConcurrentRequests' => '1024',
  'bootstrap.mlockall' => 'true',
  'node.name' => 'servinode',
  'network.publish_host' => '127.0.0.1',
  'discovery.zen.ping.multicast.enabled' => 'false',
  'discovery.zen.ping.unicast.hosts' => "[\"${::ipaddress_eth0}\", \"127.0.0.1\"]"
}

elasticsearch::instance { 'serviolastic':
  config => $config_hash,
  datadir => '/data/elasticsearch',
} 

vcsrepo { "/opt/servioticy-indices":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => [ Package["git"],  Exec['wait for elasticsearch']],
  source   => "https://github.com/servioticy/servioticy-elasticsearch-indices.git",
  revision => 'master',
  before   => [Exec['create-indices'], Exec['create-xdcr']]
} 

exec {
    'create-indices':
      command => 'sleep 10 && /bin/sh create_soupdates.sh; /bin/sh create_subscriptions.sh',
      cwd => "/opt/servioticy-indices",
      path =>  "/usr/local/bin/:/bin/:/usr/bin/",          
} 

elasticsearch::plugin{ 'mobz/elasticsearch-head':
  module_dir => 'head',
  instances  => 'serviolastic',
  require  => [ Package["git"], Package['oracle-java7-installer']],
}
