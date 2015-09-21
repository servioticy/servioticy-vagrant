class { 'kafka': }

class { 'kafka::broker':
	version => '0.8.2.1',
	scala_version => '2.10',
	install_dir => '/opt/kafka'
}
