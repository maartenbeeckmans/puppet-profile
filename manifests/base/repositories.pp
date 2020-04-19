class profile::base::repositories (
  Boolean $epel = false,
)
{
  if $facts['os']['family'] == 'RedHat' {
    class { 'epel': }
    Yumrepo['epel'] -> Package <||>
  }
}
