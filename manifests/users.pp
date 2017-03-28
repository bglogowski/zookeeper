define zookeeper::users ( $username ) {

  $uid = inline_template("<%= (@username.chars.map{|c| c.ord}.inject(:+) + 5000) + (@username.chars.map{|c| c.ord.to_s}.join.to_i % 10000) %>")
  $gid = $uid

  group { $username:
    ensure => 'present',
    gid    => $gid,
  }

  user { $username:
    ensure   => 'present',
    uid      => $uid,
    gid      => $gid,
    home     => "/home/${username}",
    password => '!',
    shell    => '/bin/bash',
    require  => Group[$username],
  }

  file { "/home/${username}/":
    ensure  => 'directory',
    owner   => $username,
    group   => $username,
    mode    => '0750',
    require => User[$username],
  }

  exec { "chown /home/${username}":
    command     => "/bin/chown -R ${username}:${username} /home/${username}",
    cwd         => '/home',
    refreshonly => true,
    subscribe   => File["/home/${username}"],
    require     => File["/home/${username}"],
  }

  file { "/home/${username}/.bashrc":
    ensure  => 'present',
    owner   => $username,
    group   => $username,
    mode    => '0755',
    backup  => false,
    content => template("zookeeper/users/${username}/bashrc.erb"),
    require => File["/home/${username}/"],
  }

  file { "/home/${username}/.bash_profile":
    ensure  => 'link',
    owner   => $username,
    group   => $username,
    target  => "/home/${username}/.bashrc",
    require => File["/home/${username}/.bashrc"],
  }

  file { "/home/${username}/.ssh/":
    ensure  => 'directory',
    owner   => $username,
    group   => $username,
    mode    => '0700',
    require => File["/home/${username}/"],
  }

  file { "/home/${username}/.ssh/authorized_keys":
    ensure  => 'file',
    owner   => $username,
    group   => $username,
    mode    => '0640',
    content => template("zookeeper/users/${username}/authorized_keys.erb"),
    require => File["/home/${username}/.ssh/"],
  }


  exec { "${username} ssh-keygen":
    command => "/bin/su -l ${username} -c '/usr/bin/ssh-keygen -t rsa -b 2048 -f /home/${username}/.ssh/id_rsa -N \"\"'",
    creates => "/home/${username}/.ssh/id_rsa",
    require => File["/home/${username}/.ssh/"],
  }

  file { "/etc/security/limits.d/${username}.conf":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("zookeeper/users/${username}/limits.conf.erb"),
  }

}
