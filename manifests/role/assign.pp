define zookeeper::role::assign ( String $zookeeper_role ) {

  if $facts['os']['family'] == 'RedHat' {
    $system_dir = '/usr/lib/systemd/system/'
  } else {
    $system_dir = '/lib/systemd/system/'
  }

  file { "/etc/zookeeper/conf/.${zookeeper_role}":
    ensure  => 'file',
    owner   => 'root',
    group   => 'zookeeper',
    mode    => '0640',
    require => File['/etc/zookeeper/conf/'],
  }

  file { "zookeeper-${zookeeper_role}.service":
    ensure  => 'file',
    path    => "${system_dir}/zookeeper-${zookeeper_role}.service",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("zookeeper/${zookeeper_role}/zookeeper-${zookeeper_role}.service.erb"),
  }

  service { "zookeeper-${zookeeper_role}":
    ensure  => 'stopped',
    enable  => false,
    require => File["zookeeper-${zookeeper_role}.service"],
  }

}
