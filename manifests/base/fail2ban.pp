class profile::base::fail2ban (
  Array $services = ['ssh', 'ssh-ddos']
)
{
  package {'fail2ban':
    ensure => present,
  }

  class { 'fail2ban':
    jails => $services
  }
}
