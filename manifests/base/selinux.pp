class profile::base::selinux (
  String $mode  = 'enforcing',
  String $type  = 'targeted',
)
{
  class { 'selinux':
    mode => $mode,
    type => $type,
  }
}
