vcsrepo { "/opt/servioticy-composer":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => [ Package["git"], Package['forever'] ],
  source   => "https://github.com/servioticy/servioticy-composer.git",
  revision => 'master',
} ->
exec { "run_composer":
  command => "forever start -a --sourceDir /opt/servioticy-composer -l /tmp/forever_red.log -o /tmp/nodered.js.out.log -e /tmp/nodered.js.err.log red.js",
  path    => "/bin:/usr/local/bin/:/usr/bin/",
  require => [Package['forever']],
  unless  => "forever list | grep forever_red"
}