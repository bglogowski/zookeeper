class zookeeper::config ( $zookeeper_version, $zookeeper_cluster, $zookeeper_role ) {

  file { '/etc/zookeeper/':
    ensure => 'directory',
    owner  => 'root',
    group  => 'zookeeper',
    mode   => '0750',
  } ->

  file { '/etc/zookeeper/conf/':
    ensure => 'directory',
    owner  => 'root',
    group  => 'zookeeper',
    mode   => '0750',
  }

  file { '/etc/zookeeper/conf/.cluster':
    ensure  => 'file',
    content => $zookeeper_cluster,
    require => File['/etc/zookeeper/conf/'],
  }

  file { '/etc/zookeeper/conf/.role':
    ensure  => 'file',
    content => $zookeeper_role,
    require => File['/etc/zookeeper/conf/'],
  }

}
