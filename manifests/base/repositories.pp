class profile::base::repositories (
  Boolean $epel = false,
)
{
  if $facts['os']['family'] == 'RedHat' and $epel {
    class { 'epel': }
    Yumrepo['epel'] -> Package <||>
  }
}
