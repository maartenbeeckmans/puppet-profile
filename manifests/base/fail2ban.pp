class profile::base::fail2ban (
  Array $services = $profile::params::fail2ban_services,
)
{
  class { 'fail2ban':
    jails => $services
  }
}
