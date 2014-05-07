class swift::proxy inherits swift {
  if !$::swift_proxy_workers {
    $workers = 8
  }
  else {
    $workers = $::swift_proxy_workers
  }

  $total_procs = 1 + $workers

  package { 'swift-proxy':
    ensure  => present,
  }

  if $openstack_version != 'essex' {
    package { 'swift-plugin-s3':
      ensure => installed,
    }
  }
  
  realize Package['python-keystone']

  file { '/etc/swift/proxy-server.conf':
    ensure  => file,
    owner   => swift,
    group   => swift,
    content => template("swift/${openstack_version}/proxy-server.conf.erb"),
    notify  => Service['swift-proxy'],
    require => Package['swift-proxy'],
  }

  file { '/etc/swift/memcache.conf':
    ensure  => file,
    owner   => swift,
    group   => swift,
    content => template("swift/${openstack_version}/memcache.conf.erb"),
    notify  => Service['swift-proxy'],
    require => Package['swift-proxy'],
  }

  service { 'swift-proxy':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/swift/swift.conf'],
  }

  include monit
  monit::package { 'rsyslog': }
  monit::package { 'sshd': }
  monit::package { 'swift-proxy': }

  # tighter pin on requests; see this bug:
  # https://bugs.launchpad.net/ubuntu/+source/python-keystoneclient/+bug/1122146
  package {'requests==0.14.2':
    provider => pip,
    ensure   => installed,
  }
}

class swift::proxy::nagios-checks {
  # These are checks that can be run by the nagios server.
  nagios::command {
    'check_swift_ssl':
      check_command => '/usr/lib/nagios/plugins/check_http --ssl -u /healthcheck -p \'$ARG1$\' -H \'$HOSTADDRESS$\' -I \'$HOSTADDRESS$\'';
    'check_swift':
      check_command => '/usr/lib/nagios/plugins/check_http -u /healthcheck -p \'$ARG1$\' -H \'$HOSTADDRESS$\' -I \'$HOSTADDRESS$\'';
    'check_swift_internal':
      check_command => '/usr/lib/nagios/plugins/check_http -p \'$ARG1$\' -e 400 -H \'$HOSTADDRESS$\' -I \'$HOSTADDRESS$\'';
  }
}
