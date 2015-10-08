exec { "install-iotp":
    cwd => "/vagrant/puppet/files/iotp",
    command => "mvn install:install-file -Dfile=IoTP-0.1.0.jar -DpomFile=pom.xml",
    user    => 'vagrant',
    group    => 'vagrant',
    require  => Class['maven::maven'],
}
