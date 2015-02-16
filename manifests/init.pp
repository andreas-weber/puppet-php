# == Class: aw_php
#
# This module manages php and the installed modules.
#
# === Parameters
#
# [*development*]
#   If the development setup should be installed.
#
# [*custom_config*]
#   Path to a custom config.
#
# [*remove_apache*]
#   If the apache webserver should be removed.
#
# === Examples
#
#   include aw_php
#
#   class { 'aw_php':
#     development   => true
#     custom_config => 'aw_php/override.ini.erb'
#     remove_apache => true
#   }
#
# === Authors
#
# Andreas Weber <code@andreas-weber.me>
#
# === Copyright
#
# Copyright 2015 Andreas Weber
#
class aw_php(
  $development = false,
  $custom_config = 'aw_php/custom.ini.erb',
  $remove_apache = true
)
{
  package {
    [
      'php5-cli',
      'php5-mcrypt',
      'php5-intl',
      'php5-mysql',
      'php5-curl',
      'php5-ssh2',
      'php5-gearman'
    ]:
      ensure  => 'latest',
      require => Class['aw_apt_dotdeb']
  }

  file { '/etc/php5/conf.d/95-custom.ini':
    ensure  => file,
    backup  => false,
    content => template('aw_php/custom.ini.erb'),
    require => Package['php5-cli']
  }

  if($development) {
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

  if($remove_apache) {
    package {
      [
        'apache2.2-common'
      ]:
        ensure  => 'purged',
        require => Package['php5-cli']
    }
  }
}
