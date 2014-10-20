# == Class: gradle
#
# Install the Gradle build system from the official project site.
# The required Java runtime environment will not be installed automatically.
#
# Supported operating systems are:
#   - Fedora Linux
#   - Debian Linux
#   - Ubuntu Linux
#
# === Parameters
#
# [*version*]
#   Specify the version of Gradle which should be installed.
#
# [*base_url*]
#   Specify the base URL of the Gradle ZIP archive. Usually this doesn't
#   need to be changed.
#
# [*url*]
#   Specify the absolute URL of the Gradle ZIP archive. This overrides any
#   version which has been set before.
#
# [*target*]
#   Specify the location of the symlink to the Gradle installation on the local
#   filesystem.
#
# [*daemon*]
#   Specify if the Gradle daemon should be running
#
# === Variables
#
# The variables being used by this module are named exactly like the class
# parameters with the prefix 'gradle_', e. g. *gradle_version* and *gradle_url*.
#
# === Examples
#
#  class { 'gradle':
#    version => '1.8'
#  }
#
# === Authors
#
# Jochen Schalanda <j.schalanda@gini.net>
#
# === Copyright
#
# Copyright 2012, 2013 smarchive GmbH, 2013 Gini GmbH
#
class gradle(
  $version  = 'UNSET',
  $base_url = 'UNSET',
  $url      = 'UNSET',
  $target   = 'UNSET',
  $timeout  = 120,
  $daemon   = true
) {

  include gradle::params

  $version_real = $version ? {
    'UNSET' => $::gradle::params::version,
    default => $version,
  }

  $base_url_real = $base_url ? {
    'UNSET' => $::gradle::params::base_url,
    default => $base_url,
  }

  $url_real = $url ? {
    'UNSET' => "${base_url_real}/gradle-${version_real}-all.zip",
    default => $url,
  }

  $target_real = $target ? {
    'UNSET' => $::gradle::params::target,
    default => $target,
  }

  Exec {
    path  => [
      '/usr/local/sbin', '/usr/local/bin',
      '/usr/sbin', '/usr/bin', '/sbin', '/bin',
    ],
    user  => 'root',
    group => 'root',
  }

  archive { "gradle-${version_real}-all.zip":
    ensure     => present,
    url        => $url_real,
    checksum   => false,
    src_target => '/var/tmp',
    target     => '/opt',
    root_dir   => "gradle-${version_real}",
    extension  => 'zip',
    timeout    => $timeout,
  }

  file { $target_real:
    ensure  => link,
    target  => "/opt/gradle-${version_real}",
    require => Archive["gradle-${version_real}-all.zip"],
  }

  file { '/etc/profile.d/gradle.sh':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/gradle.sh.erb"),
  }
}
