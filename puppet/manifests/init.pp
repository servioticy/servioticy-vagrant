include wget, git, apt

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin/"] }

#lvm::volume { 'data':
#  ensure => present,
#  vg     => 'data',
#  pv     => '/dev/sdb',
#  fstype => 'ext4',
#  size   => '1G',
#}->
#fstab { 'A test fstab entry':
#  source => '/dev/sdb1',
# dest   => '/data',
#  type   => 'ext4',
#  before => File['/data/couchbase']
#}







