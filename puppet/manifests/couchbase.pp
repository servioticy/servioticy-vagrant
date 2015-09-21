wget::fetch { "couchbase-server-source":
  source      => 'http://packages.couchbase.com/releases/3.1.0/couchbase-server-enterprise_3.1.0-ubuntu12.04_amd64.deb',
  destination => '/home/vagrant/downloads/couchbase-server-enterprise_3.1.0-ubuntu12.04_amd64.deb',
  timeout     => 0,
  verbose     => false,
  require     => File['/home/vagrant/downloads/']
} ->
package { "couchbase-server":
  provider => dpkg,
  ensure => installed,
  source => "/home/vagrant/downloads/couchbase-server-enterprise_3.1.0-ubuntu12.04_amd64.deb"
} 


exec {"stop_couchbase":
  require => [Package['couchbase-server']],
  command => "/etc/init.d/couchbase-server stop",
}

