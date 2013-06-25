# Class: qpid::server
#
# This module manages the installation and config of the qpid server
class qpid::server(
  $running = 'running',
  $auth   = 'yes'
) {

  package {"qpid-cpp-server":
      ensure => installed,
  }

  service {"qpidd":
      ensure  => $running,
      enable  => true,
      require => Package["qpid-cpp-server"],
      subscribe => File['/etc/qpidd.conf'],
  }

  if $::operatingsystem == 'Fedora' {
    $mechanism_option = 'ha-mechanism'
    package {"qpid-cpp-server-ha":
      ensure => installed,
    }
  }
  else {
    $mechanism_option = 'cluster-mechanism'
    package {"qpid-cpp-server-cluster":
      ensure => installed,
    }
  }
  file { "/etc/qpidd.conf":
    content => template('qpid/qpidd.conf.erb'),
    mode    => '0644',
  }

}
