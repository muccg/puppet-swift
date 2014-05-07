class swift::container {

  if !$::swift_container_workers {
    $workers = 2
    } else {
    $workers = $::swift_container_workers
  }

  $total_procs = 1 + $workers

  package { 'swift-container':
    ensure => present,
  }

  file { '/etc/swift/container-server.conf':
    ensure  => present,
    owner   => swift,
    group   => swift,
    require => Package['swift-container'],
    content => template("swift/${openstack_version}/container-server.conf.erb"),
  }

  service { 'swift-container':
    ensure    => running,
    enable    => true,
    subscribe => [ File['/etc/swift/container-server.conf'],
                   File['/etc/swift/swift.conf']],
  }

  service { 'swift-container-replicator':
    ensure    => running,
    enable    => true,
    subscribe => [ File['/etc/swift/container-server.conf'],
                   File['/etc/swift/swift.conf']],
  }

  service { 'swift-container-updater':
    ensure    => running,
    enable    => true,
    subscribe => [ File['/etc/swift/container-server.conf'],
                   File['/etc/swift/swift.conf']],
  }

  service { 'swift-container-auditor':
    ensure    => running,
    enable    => true,
    subscribe => [ File['/etc/swift/container-server.conf'],
                   File['/etc/swift/swift.conf']],
  }
}
