vcsrepo { "/opt/demo":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => [ Package["git"] ],
  source   => "https://github.com/servioticy/servioticy-demo.git",
  revision => 'master',
} ->
file { '/opt/demo/env.sh':
          ensure => present,
          replace => true,
          owner    => 'vagrant',
          group    => 'vagrant',
          source => "/vagrant/puppet/files/env.sh"
}
