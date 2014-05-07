class swift::account {

  if !$::swift_account_workers {
    $workers = 2
    } else {
    $workers = $::swift_account_workers
  }

  $total_procs = 1 + $workers

  package { 'swift-account':
    ensure => present,
  }

  file { '/etc/swift/account-server.conf':
    ensure  => present,
    owner   => swift,
    group   => swift,
    require => Package['swift-account'],
    content => template("swift/${openstack_version}/account-server.conf.erb"),
  }

  service { 'swift-account':
    ensure    => running,
    enable    => true,
    subscribe => [ File['/etc/swift/account-server.conf'],
                   File['/etc/swift/swift.conf']],
  }

  service { 'swift-account-replicator':
    ensure    => running,
    enable    => true,
    subscribe => [ File['/etc/swift/account-server.conf'],
                   File['/etc/swift/swift.conf']],
  }

  service { 'swift-account-auditor':
    ensure    => running,
    enable    => true,
    subscribe => [ File['/etc/swift/account-server.conf'],
                   File['/etc/swift/swift.conf']],
  }
}
