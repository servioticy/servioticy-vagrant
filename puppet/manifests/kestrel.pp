archive { 'kestrel-2.4.1':
  ensure => present,
  follow_redirects => true,
  extension => "zip",
  checksum => false,
  url    => 'http://twitter.github.io/kestrel/download/kestrel-2.4.1.zip',
  target => '/opt',
  src_target => '/home/vagrant/downloads',
  require  => [ Package["curl"], Package["unzip"], File['/home/vagrant/downloads/'] ],
} ->
file { '/opt/kestrel-2.4.1':
  owner    => 'vagrant',
  group    => 'vagrant'
} ->
file { '/opt/kestrel-2.4.1/config/servioticy_queues.scala':
          ensure => present,
          source => "/vagrant/puppet/files/servioticy_queues.scala",
          owner    => 'vagrant',
          group    => 'vagrant',
} ->
exec { "run_kestrel":
    command => "java -server -Xmx1024m -Dstage=servioticy_queues -jar /opt/kestrel-2.4.1/kestrel_2.9.2-2.4.1.jar &",
    cwd     => "/opt/kestrel-2.4.1",
    require => Package['oracle-java7-installer'] ,
    user    => 'vagrant',
    group    => 'vagrant',
    unless => "ps -fA | grep kestrel | grep -v grep",
}