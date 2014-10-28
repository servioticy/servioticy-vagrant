vcsrepo { "/opt/servioticy-service-manager":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  source   => "https://github.com/muka/servioticy-mgr.git",
  revision => 'master',
}