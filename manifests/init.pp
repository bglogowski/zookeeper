# observer or participant

class zookeeper (
    String $zookeeper_version = '3.4.9',
    String $zookeeper_cluster = 'default',
    String $zookeeper_role = 'participant'
  ) {


  [ 'zookeeper' ].each |String $user| {

    zookeeper::users { $user:
      username => $user,
      before   => Class['zookeeper::install'],
    }

  }


    class { 'zookeeper::install':
      zookeeper_version   => $zookeeper_version,
    } ->

    class { 'zookeeper::config':
      zookeeper_version => $zookeeper_version,
      zookeeper_cluster => $zookeeper_cluster,
      zookeeper_role    => $zookeeper_role,
    }

}
