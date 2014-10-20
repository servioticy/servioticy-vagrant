vcsrepo { "/usr/src/compose-idm":
  ensure   => latest,
  provider => git,
  owner    => 'vagrant',
  group    => 'vagrant',
  require  => [ Package["git"], Class['Maven'], Package['oracle-java7-installer'], Package['curl'], Packag['unzip'] ],
  source   => "https://github.com/nopobyte/compose-idm",
  revision => 'master',
} ->
exec { "compose-idm",
    path => "/usr/local/bin/:/usr/bin:/bin/:/usr/src/compose-idm:/opt/gradle-2.1/bin",
    cwd => "/usr/src/compose-idm",
    command => "sh compile-jar.sh",
    user    => 'vagrant',
    group    => 'vagrant',
    require => Class['gradle']
} 