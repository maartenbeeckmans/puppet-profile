class profile::base::repositories (
  Boolean $epel = true,
)
{
  if $facts['os']['family'] == 'RedHat' and $epel {
    class { 'epel': }
    Yumrepo['epel'] -> Package <||>
  }
}
