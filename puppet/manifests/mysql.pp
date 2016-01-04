class { '::mysql::server':}

mysql::db { 'servioticyidentity':
  user     => 'servioticy',
  password => 'password',
  host     => 'localhost',
}


mysql_grant { 'root@localhost/*.*':
  ensure     => 'present',
  options    => ['GRANT'],
  privileges => ['ALL'],
  table      => '*.*',
  user       => 'root@localhost',
}
