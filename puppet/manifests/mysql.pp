class { '::mysql::server':
  root_password    => 'root',
}

#mysql::db { 'composeidentity2':
#  user     => 'foo',
#  password => 'foo',
#  host     => 'localhost',
#  grant    => ['ALL']
#}

mysql_database { 'composeidentity2':
  ensure  => 'present',
} ->
mysql_grant { 'root@localhost/*.*':
  ensure     => 'present',
  options    => ['GRANT'],
  privileges => ['ALL'],
  table      => '*.*',
  user       => 'root@localhost',
}