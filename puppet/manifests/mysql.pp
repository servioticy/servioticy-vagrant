class { '::mysql::server':
  root_password    => 'root',
}

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