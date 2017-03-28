class zookeeper (
    $zookeeper_version   = '3.4.9',
    $zookeeper_cluster   = 'default',
    $zookeeper_role      = 'regionserver',
  ) {


    class { 'zookeeper::users':
      zookeeper_cluster => $zookeeper_cluster,
    } ->

    class { 'zookeeper::install':
      zookeeper_version   => $zookeeper_version,
    } ->

    class { 'zookeeper::config':
      zookeeper_version => $zookeeper_version,
      zookeeper_cluster => $zookeeper_cluster,
      zookeeper_role    => $zookeeper_role,
    }

}
