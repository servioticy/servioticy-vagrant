archive { 'apache-storm-0.9.5':
  ensure => present,
  follow_redirects => true,
  checksum => false,
  url    => 'http://www.eu.apache.org/dist/storm/apache-storm-0.9.5/apache-storm-0.9.5.tar.gz',
  target => '/opt',
  src_target => '/home/vagrant/downloads',
  require  => [ Package["curl"], File['/home/vagrant/downloads/'] ],
} ->
file { '/opt/apache-storm-0.9.5':
  owner    => 'vagrant',
  group    => 'vagrant',

}

