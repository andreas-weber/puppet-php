# == Class: aw_php::development
#
# This module manages the development environment.
#
# === Parameters
#
# === Examples
#
#   include aw_php::development
#
#   class { 'aw_php::development': }
#
# === Authors
#
# Andreas Weber <code@andreas-weber.me>
#
# === Copyright
#
# Copyright 2015 Andreas Weber
#
class aw_php::development()
{
  package { 'php5-xdebug':
    ensure  => 'latest',
    require => Class['aw_apt_dotdeb']
  }

  file { '/etc/php5/conf.d/99-development.ini':
    ensure  => file,
    backup  => false,
    content => template('aw_php/development.ini.erb'),
    require => Package['php5-cli']
  }

  file { '/etc/php5/conf.d/99-xdebug.ini':
    ensure  => file,
    backup  => false,
    content => template('aw_php/xdebug.ini.erb'),
    require => Package['php5-xdebug']
  }

  file { '/usr/bin/php-debug':
    ensure  => file,
    backup  => false,
    content => template('aw_php/php-debug.erb'),
    mode    => 0777,
    require => Package['php5-xdebug']
  }

  file { '/etc/profile.d/php-debug-alias.sh':
    ensure  => file,
    backup  => false,
    content => template('aw_php/php-debug-alias.sh.erb'),
    mode    => 0644,
    require => Package['php5-xdebug']
  }
}
