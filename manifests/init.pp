# == Class: watchdog
#
# Install and configure watchdog daemon

class watchdog (
  $watchdog_device = "/dev/watchdog",
  $watchdog_timeout = 300,
  $interval = 10
) { 
  
  case $::operatingsystem {
    'Ubuntu' : { 

      package { 'openipmi':
        ensure => present,
      }

      package { 'ipmitool':
        ensure => present,
      }

      package { 'watchdog':
        ensure => 'watchdog',
        before => File['/etc/watchdog.conf'],
      }

      file { '/etc/watchdog.conf':
        ensure  => file,
        mode    => 600,
        owner   => 'root',
        content => template('watchdog/watchdog.conf.erb'),
      }

      service { 'watchdog':
        ensure    => running,
        enable    => true,
        subscribe => File['/etc/watchdog.conf'],
      }

      file_line { 'modules_to_load':
        path => '/etc/modules',
        line => 'ipmi_watchdog',
      }
    }
  }
}
