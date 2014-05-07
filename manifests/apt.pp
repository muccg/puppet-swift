class swift::apt {
  
    # We don't want to just apt-get upgrade willy nilly... so it is
    # controlled by updating dummy file.
    # http://projects.puppetlabs.com/projects/1/wiki/debian_patterns#Problem

    exec { "/usr/bin/apt-get -y upgrade":
      refreshonly => true,
      timeout => 3600,
      require => Exec['apt-get-update'],
      subscribe   => File["/etc/do_apt_upgrade_storage"],
    }

    file { "/etc/do_apt_upgrade_storage":
      source => "puppet:///modules/swift/do_apt_upgrade_storage",
    }
}
