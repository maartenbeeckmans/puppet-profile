# == Class: profile::storage::ceph ==
class profile::storage::ceph (
  Boolean $manage_repo         = true,
  Boolean $is_mgr              = false,
  Boolean $is_mon              = false,
  Boolean $has_osd             = false,
  String  $authentication_type = 'none',
  String  $fsid                = '066F558C-6789-4A93-AAF1-5AF1BA01A3AD',
  String  $mon_host            = 'node1',
  String  $mon_initial_members = 'node1',
  Hash    $osd_list            = {
    '/dev/sdb' =>  { journal => '/tmp/sdb' },
  }
)
{
  if $manage_repo {
    class { 'ceph::repo': }
  }
  class { 'ceph':
    fsid                => $fsid,
    mon_host            => $mon_host,
    mon_initial_members => $mon_initial_members,
    authentication_type => $authentication_type,
  }
  if $is_mgr {
    ceph::mgr { $::hostname:
      authentication_type => $authentication_type,
    }
  }
  if $is_mon {
    ceph::mon { $::hostname:
      authentication_type => $authentication_type,
    }
  }
  if $has_osd {
    create_resources(::ceph::osd, $osd_list)
  }
}
