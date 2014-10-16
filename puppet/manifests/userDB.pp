file { '/data/userDB':
          ensure => directory,
          replace => true,
          owner    => 'vagrant',
          group    => 'vagrant',          
          source => "/vagrant/puppet/files/userDB",
          recurse => remote,
          before     => Exec['run_userDB']
}

exec { 'run_userDB':
    require => [ Package['python-pip'], File['/data/userDB']],
    user    => 'vagrant',
    group    => 'vagrant',
    unless => "ps -fA | grep userDB | grep -v grep",          
    cwd => "/data/userDB/",
    path => "/bin:/usr/bin/",
    command => "python userDB.py &"
}