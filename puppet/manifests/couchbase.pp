wget::fetch { "couchbase-server-source":
  source      => 'http://packages.couchbase.com/releases/3.0.0/couchbase-server-enterprise_3.0.0-ubuntu12.04_amd64.deb',
  destination => '/home/vagrant/downloads/couchbase-server-enterprise_3.0.0-ubuntu12.04_amd64.deb',
  timeout     => 0,
  verbose     => false,
  require     => File['/home/vagrant/downloads/']
} ->
package { "couchbase-server":
  provider => dpkg,
  ensure => installed,
  source => "/home/vagrant/downloads/couchbase-server-enterprise_3.0.0-ubuntu12.04_amd64.deb"
}

exec {"wait for couchbase":
  require => Package['couchbase-server'],
  command => "/usr/bin/wget --spider --tries 10 --retry-connrefused --no-check-certificate http://localhost:8091/pools/default/buckets ",
}

exec { "create_buckets":
    command => "/bin/sh create_buckets.sh",
    cwd     => "/vagrant/puppet/files",
    path    => "/bin:/usr/bin/:/opt/couchbase/bin/",
    #logoutput => true,
    require => [Exec['wait for couchbase'], Package['curl']]
}