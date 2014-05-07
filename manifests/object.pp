class swift::object {

  if !$::swift_object_workers {
    $workers = 2
    } else {
    $workers = $::swift_object_workers
  }

  $total_procs = 1 + $workers

  package { 'swift-object':
    ensure => present,
  }

  file { '/etc/swift/object-server.conf':
    ensure  => present,
    owner   => swift,
    group   => swift,
    require => Package['swift-object'],
    content => template("swift/${openstack_version}/object-server.conf.erb"),
  }

  service { 'swift-object':
    ensure    => running,
    enable    => true,
    subscribe => [ File['/etc/swift/object-server.conf'],
                   File['/etc/swift/swift.conf']],
  }

  service { 'swift-object-replicator':
    ensure    => running,
    enable    => true,
    subscribe => [ File['/etc/swift/object-server.conf'],
                   File['/etc/swift/swift.conf']],
  }

  service { 'swift-object-updater':
    ensure    => running,
    enable    => true,
    subscribe => [ File['/etc/swift/object-server.conf'],
                   File['/etc/swift/swift.conf']],
  }

  service { 'swift-object-auditor':
    ensure    => running,
    enable    => true,
    subscribe => [ File['/etc/swift/object-server.conf'],
                   File['/etc/swift/swift.conf']],
  }

}
