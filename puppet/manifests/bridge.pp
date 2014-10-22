vcsrepo { "/opt/servioticy-bridge":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => [ Package["git"], Package['forever'] ],
  source   => "https://github.com/servioticy/servioticy-brokers.git",
  revision => 'master'
} 
#->
#exec { "run_bridge":
#  command => "forever start -a --sourceDir /opt/servioticy-bridge -l /tmp/forever_bridge.log -o /tmp/bridge.js.out.log -e /tmp/bridge.js.err.log mqtt-and-stomp-bridge.js",
#  path    => "/bin:/usr/local/bin/:/usr/bin/",
#  require => [Package['forever'], Package['stompjs']],
#  unless  => "forever list | grep bridge"
#}