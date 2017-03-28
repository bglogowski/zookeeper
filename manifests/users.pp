class zookeeper::users ( $zookeeper_cluster ) {

  $rsa_2048_keys = query_facts("zookeeper.installed=true and zookeeper.cluster=${zookeeper_cluster}", ["zookeeper.rsa_2048_key"])

  group { 'zookeeper':
    ensure => 'present',
    gid    => '5100',
  }

  user { 'zookeeper':
    ensure   => 'present',
    comment  => 'HBase Service User',
    uid      => '5100',
    gid      => '5100',
    home     => '/home/zookeeper',
    password => '!',
    shell    => '/bin/bash',
    require  => Group['zookeeper'],
  }

  file { '/home/zookeeper/':
    ensure  => 'directory',
    owner   => 'zookeeper',
    group   => 'zookeeper',
    mode    => '0750',
    require => User['zookeeper'],
  }

  file { '/home/zookeeper/.bashrc':
    ensure  => 'present',
    owner   => 'zookeeper',
    group   => 'zookeeper',
    mode    => '0755',
    backup  => false,
    source  => "puppet:///modules/zookeeper/bashrc",
    require => File['/home/zookeeper/'],
  } ->

  file { '/home/zookeeper/.bash_profile':
    ensure  => 'link',
    target  => '/home/zookeeper/.bashrc',
    require => File['/home/zookeeper/.bashrc'],
  }

  file { '/home/zookeeper/.ssh/':
    ensure  => 'directory',
    owner   => 'zookeeper',
    group   => 'zookeeper',
    mode    => '0700',
    require => File['/home/zookeeper/'],
  }

  file { '/home/zookeeper/.ssh/authorized_keys':
    ensure  => 'file',
    owner   => 'zookeeper',
    group   => 'zookeeper',
    mode    => '0640',
    content => template('zookeeper/authorized_keys.erb'),
    require => File['/home/zookeeper/.ssh/'],
  }

  exec { 'zookeeper ssh-keygen':
    command => '/bin/su -l zookeeper -c \'/usr/bin/ssh-keygen -t rsa -b 2048 -f /home/zookeeper/.ssh/id_rsa -N ""\'',
    creates => '/home/zookeeper/.ssh/id_rsa',
    require => File['/home/zookeeper/.ssh/'],
  }

  # /etc/security/limits.d/zookeeper

}
