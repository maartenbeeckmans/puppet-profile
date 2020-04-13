class profile::firewall (
  Boolean $purge            = $profile::params::firewall_purge,
  Boolean $purge_unmanaged  = $profile::params::firewall_purge_unmanaged,
)
{
  resources { 'firewall':
    purge => $purge,
  }
  
  resources { 'firewallchain':
    purge => $purge_unmanaged,
  }

  Firewall {
    before  =>  Class['profile::firewall::post'],
    require =>  Class['profile::firewall::pre'],
  }

  class { ['profile::firewall::pre', 'profile::firewall::post']: }
  class { 'firewall': }
}
