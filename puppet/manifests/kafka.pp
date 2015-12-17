class { 'kafka':
  version => '0.8.2.2',
  scala_version => '2.10'
}

class { 'kafka::broker':
  config => { 'broker.id' => '0', 'zookeeper.connect' => 'localhost:2181' }
} 
