
class zookeeper::install ( $zookeeper_version ) {

  $mirror = lookup( "mirrors.apache.${fqdn_rand(10)}" )
  $checksum = lookup( 'checksums.zookeeper' )[$zookeeper_version]['sha256']

  if ($facts['zookeeper']['installed'] == true) and ($facts['zookeeper']['version'] == $zookeeper_version) {

    file {"/var/tmp/zookeeper-${zookeeper_version}.tar.gz":
      ensure => 'absent',
      backup => false,
    }

  } else {

    file { "/var/tmp/zookeeper-${zookeeper_version}.tar.gz":
      ensure         => 'present',
      owner          => 'root',
      group          => 'root',
      mode           => '0644',
      checksum       => 'sha256',
      checksum_value => $checksum,
      backup         => false,
      source         => "http://${mirror}/zookeeper/zookeeper-${zookeeper_version}/zookeeper-${zookeeper_version}.tar.gz",
      notify         => Exec["untar zookeeper-${zookeeper_version}"],
    }

    exec { "untar zookeeper-${zookeeper_version}":
      command     => "/bin/tar xf /var/tmp/zookeeper-${zookeeper_version}.tar.gz",
      cwd         => '/opt',
      refreshonly => true,
      require     => File["/var/tmp/zookeeper-${zookeeper_version}.tar.gz"],
      notify      => Exec["chown zookeeper-${zookeeper_version}"],
    } ->

    exec { "chown zookeeper-${zookeeper_version}":
      command     => "/bin/chown -R root:root /opt/zookeeper-${zookeeper_version}",
      cwd         => '/opt',
      refreshonly => true,
      require     => File["/var/tmp/zookeeper-${zookeeper_version}.tar.gz"],
    } ->

    file { '/opt/zookeeper':
      ensure  => 'link',
      target  => "/opt/zookeeper-${zookeeper_version}",
      require => File["/var/tmp/zookeeper-${zookeeper_version}.tar.gz"],
    }

  }

}
