# == Class: aw_php::fpm
#
# This module manages the php fpm module.
#
# === Parameters
#
# === Examples
#
#   include aw_php::fpm
#
#   class { 'aw_php::fpm': }
#
# === Authors
#
# Andreas Weber <code@andreas-weber.me>
#
# === Copyright
#
# Copyright 2015 Andreas Weber
#
class aw_php::fpm()
{
  package {
    [
      'php5-fpm'
    ]:
      ensure  => 'latest',
      require => Class['aw_apt_dotdeb']
  }

  service { 'php5-fpm':
    ensure     => 'running',
    enable     => true,
    require    => Package['php5-fpm']
  }
}
