archive { 'apache-storm-0.9.1':
  ensure => present,
  follow_redirects => true,
  checksum => false,
  url    => 'http://ftp.cixug.es/apache/incubator/storm/apache-storm-0.9.1-incubating/apache-storm-0.9.1-incubating.tar.gz',
  target => '/opt',
  src_target => '/home/vagrant/downloads',
  require  => [ Package["curl"], File['/home/vagrant/downloads/'] ],
}

exec { "run_storm":
    command => "storm jar /opt/servioticy-dispatcher/dispatcher-0.2.1-jar-with-dependencies.jar com.servioticy.dispatcher.DispatcherTopology -f /opt/servioticy-dispatcher/dispatcher.xml &",
    cwd     => "/opt/apache-storm-0.9.1-incubating",
    require => [Exec['run_kestrel'], File['/opt/servioticy-dispatcher/dispatcher-0.2.1-jar-with-dependencies.jar'], File['/opt/servioticy-dispatcher/dispatcher.xml']],
    user    => 'vagrant',
    group    => 'vagrant',
    path    => "/bin:/usr/bin/:/opt/apache-storm-0.9.1-incubating/bin",
    unless => "ps -fA | grep storm | grep -v grep",
}