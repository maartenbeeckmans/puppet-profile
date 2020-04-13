class profile::base::selinux (
  String $mode  = $profile::params::selinux_mode,
  String $type  = $profile::params::selinux_type,
)
{
  class { 'selinux':
    mode => $mode,
    type => $type,
  }
}
