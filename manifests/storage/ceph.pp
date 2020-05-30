# == Class: profile::storage::ceph
#
# Module manages ceph cluster
#
# === Dependencies
#
# - openstack-ceph
#
# === Parameters
#
# $manage_repo          Manage ceph software repository
#
# $is_mon               Is Ceph Monitor
#
# $has_osd              Contains Ceph Object Storage Deamons
#
# $is_mgr               Is Ceph Manager
#
# $is_mds               Is Ceph Metadate Server
#
# $is_client            Configura a Ceph Client
#
# $authentication_type  Used authentication type, default is none,
#                       to use authentication, set to cephx  
#
# $fsid                 The FSID of the ceph cluster,
#                       generate with `uuidgen`
#
# $mon_host             List of monitor FQDN's or IP's
#
# $mon_initial_members  List of monitor ID's
#
# $osd_list             Hash of Object Storage Deamons
#
# $pool_list            Hash of Ceph pools
#
# $fs_list              Hash of Ceph filesystems
#
# $admin_key            Admin key,
#                       Optional, required if authentication type is cephx
#                       Can be generated with ceph-authtool --gen-print-key
#
# $mon_key              Monitor key,
#                       Optional, required if authentication type is cephx
#                       Can be generated with ceph-authtool --gen-print-key
#
# $bootstrap_osd_key    Bootstrap Object Storage Deamon Key
#                       Optional, required if authentication type is cephx
#                       Can be generated with ceph-authtool --gen-print-key
#
class profile::storage::ceph (
  Boolean           $manage_repo         = true,
  Boolean           $is_mon              = false,
  Boolean           $has_osd             = false,
  Boolean           $is_mgr              = false,
  Boolean           $is_mds              = false,
  Boolean           $is_client           = false,
  String            $authentication_type = 'none',
  String            $fsid                = '066F558C-6789-4A93-AAF1-5AF1BA01A3AD',
  String            $mon_host            = 'node1',
  String            $mon_initial_members = 'node1',
  Hash              $osd_list            = {
    '/dev/sdb' =>  { journal => '/tmp/sdb' },
  },
  Hash              $pool_list           = {
    'metadata' => {
      ensure => present,
      size   => 1,
      tag    => 'cephfs',
    },
    'data'   => {
      ensure => present,
      size   => 1,
      tag    => 'cephfs',
    },
  },
  Hash              $fs_list             = {
    'default'     => {
      metadata_pool => 'metadata',
      data_pool     => 'data',
    }
  },
  Optional[String]  $admin_key           = undef,
  Optional[String]  $mon_key             = undef,
  Optional[String]  $bootstrap_osd_key   = undef,
  Optional[String]  $mgr_key             = undef,
)
{
  if $authentication_type == 'cephx' {
    if !$admin_key and !$mon_key and !$bootstrap_osd_key {
      fail()
    }
  }
  if $manage_repo {
    class { 'ceph::repo': }
  }
  class { 'ceph':
    fsid                => $fsid,
    mon_host            => $mon_host,
    mon_initial_members => $mon_initial_members,
    authentication_type => $authentication_type,
  }
  if $is_mon {
    if $authentication_type == 'cephx' {
      ceph::mon { $::hostname:
        authentication_type => $authentication_type,
        key                 => $mon_key,
      }
      Ceph::Key {
        inject         => true,
        inject_as_id   => 'mon.',
        inject_keyring => "/var/lib/ceph/mon/ceph-${::hostname}/keyring",
      }
      ceph::key { 'client.admin':
        secret  => $admin_key,
        cap_mon => 'allow *',
        cap_osd => 'allow *',
        cap_mds => 'allow',
      }
      ceph::key { 'client.bootstrap-osd':
        secret  => $bootstrap_osd_key,
        cap_mon => 'allow profile bootstrap-osd',
      }
    } else {
      ceph::mon { $::hostname:
        authentication_type => $authentication_type,
      }
    }
  }
  if $has_osd {
    create_resources(::ceph::osd, $osd_list)
    # Key is already defined in mon section
    if $authentication_type == 'cephx' and ! $is_mon {
      ceph::key { 'client.bootstrap-osd':
        keyring_path => '/var/lib/ceph/bootstrap-osd/ceph.keyring',
        secret       => $bootstrap_osd_key,
      }
    }
  }
  if $is_mgr {
    if $authentication_type {
      ceph::mgr { $::hostname:
        authentication_type => $authentication_type,
        key                 => $mgr_key,
      }
    } else {
      ceph::mgr { $::hostname:
        authentication_type => $authentication_type,
      }
    }
  }
  if $is_mds {
    class {'::ceph::mds':
      public_addr => $facts['networking']['ip'],
    }
  }
  if $is_client {
    ceph::key { 'client.admin':
      secret => $admin_key,
    }
  }
  create_resources(::ceph::pool,$pool_list)
  create_resources(::ceph::fs,$fs_list)
}
