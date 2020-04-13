class profile::base::selinux (
  String $mode  = $profile::base::params::selinux_mode,
  String $type  = $profile::base::params::selinux_type,
)
{
  class { 'selinux':
    mode => $mode,
    type => $type,
  }
}
